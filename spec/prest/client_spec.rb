# frozen_string_literal: true

RSpec.describe Prest do
  let(:parsed_response) { {} }
  let(:code) { 200 }
  let(:headers) { {} }
  let!(:response_mock) do
    double(:response, code: code, parsed_response: parsed_response, headers: headers)
  end

  before do
    %i[get post put patch delete].each do |http_method|
      allow(HTTParty).to receive(http_method).and_return(response_mock)
    end

    # Add #fragments and #query_params to the instance of Prest::Client only in the tests.
    Prest::Client.class_eval { attr_reader :fragments, :query_params }
  end

  describe 'method chaining' do
    let(:base_uri) { 'https://api.example.com' }
    let(:options) { {} }
    let(:client) { Prest::Client.new(base_uri, options) }

    subject { client.method1.method2.method3 }

    it 'adds each fragment to the fragments array' do
      subject
      expect(client.fragments).to eq(%w[method1 method2 method3])
    end

    it 'returns an instance of Prest::Client' do
      expect(subject).to be_a(Prest::Client)
    end

    context 'when fragment contains an underscore' do
      subject { client.fragment_name.example }

      it 'creates a url with underscores' do
        expect { subject }.to change { client.fragments }.to(%w[fragment_name example])
      end
    end

    context 'when fragment contains two consecutive underscores' do
      subject { client.fragment__name }

      it 'replaces them with hyphens' do
        expect { subject }.to change { client.fragments }.to(['fragment-name'])
      end
    end

    context 'when fragment is called with params' do
      let(:param) { 'param' }
      subject { client.fragment_name(param).fragment }

      it 'adds the param to url' do
        subject
        expect(client.fragments).to eq(["fragment_name/#{param}", 'fragment'])
      end
    end

    context 'when fragment is called with keyword params' do
      let(:param) { 'param' }
      subject { client.fragment_name(param: param).fragment }

      it 'does not add the param to the fragments' do
        subject
        expect(client.fragments).to eq(%w[fragment_name fragment])
      end

      it 'adds the param to the query_params' do
        subject
        expect(client.query_params).to eq(param: param)
      end

      context 'when the __query_param key passed as a keyword argument' do
        let(:param) { 'param[]=1&param[]=2' }
        subject { client.fragment_name(__query_params: param).fragment }

        it 'adds the param to the query_params' do
          subject
          expect(client.query_params).to eq(__query_params: [param])
        end
      end
    end
  end

  %i[get post put patch delete].each do |http_method|
    describe "\##{http_method}" do
      let(:options) { {} }
      let(:client) { Prest::Client.new(base_uri, options) }
      let(:base_uri) { 'https://api.example.com' }
      let(:body) { {} }
      subject { client.__send__(http_method, body: body) }

      context 'when headers are passed' do
        let(:options) { { headers: { key: 'value' } } }

        it "calls HTTParty\##{http_method} with correct params" do
          expect(HTTParty).to receive(http_method).with("#{base_uri}/", body: {}, headers: options[:headers])
          subject
        end

        include_examples 'returns a correct response'
      end

      context 'when json option is passed' do
        let(:options) { { json: true } }

        it "calls HTTParty\##{http_method} with Content-Type and Accept headers" do
          expect(HTTParty).to receive(http_method).with("#{base_uri}/", body: {},
                                                                        headers: {
                                                                          'Content-Type' => 'application/json',
                                                                          'Accept' => 'application/json'
                                                                        })
          subject
        end

        include_examples 'returns a correct response'
      end

      context 'when body is passed' do
        let(:body) { { key: 'value' } }

        it "calls HTTParty\##{http_method} with correct params" do
          expect(HTTParty).to receive(http_method).with("#{base_uri}/", body: body, headers: {})
          subject
        end

        include_examples 'returns a correct response'
      end

      context 'when query params are passed' do
        subject { client.fragment_name(param: 'value', __query_params: 'key=1&key=2').__send__(http_method) }

        it "calls HTTParty\##{http_method} with correct params" do
          expect(HTTParty).to receive(http_method).with("#{base_uri}/fragment_name?key=1&key=2&param=value",
                                                        body: {},
                                                        headers: {})
          subject
        end

        include_examples 'returns a correct response'
      end

      describe 'accessing the response params' do
        let!(:parsed_response) { { key: 'value' } }
        let!(:headers) { { 'Content-Type' => 'application/json' } }

        include_examples 'returns a correct response'

        include_examples 'forwards methods to httparty\'s response'

        context 'when the response is not successful' do
          let!(:code) { 400 }

          include_examples 'forwards methods to httparty\'s response'
        end
      end
    end
  end

  %i[get! post! put! patch! delete!].each do |dangerous_http_method|
    describe "\##{dangerous_http_method}" do
      let(:options) { {} }
      let(:http_method) { dangerous_http_method.to_s[0..-2] }
      let(:client) { Prest::Client.new(base_uri, options) }
      let(:base_uri) { 'https://api.example.com' }
      let(:body) { {} }

      subject { client.__send__(dangerous_http_method, body: body) }

      context 'when the request is successful' do
        let!(:parsed_response) { { key: 'value' } }
        let!(:headers) { { 'Content-Type' => 'application/json' } }
        let!(:code) { 200 }

        include_examples 'forwards methods to httparty\'s response'
      end

      context 'when the request is not successful' do
        let(:code) { 500 }
        let(:parsed_response) { { error: 'This is an error from the API' } }

        it 'raises a ::Prest::RequestError' do
          expect { subject }.to raise_error(::Prest::RequestError)
        end

        it 'returns the ::Prest::Response object in the error' do
          expect { subject }.to raise_error(::Prest::RequestError) { |error|
            expect(error.message).to eq(parsed_response.to_json)
          }
        end

        it 'assigns the headers to the error' do
          expect { subject }.to raise_error(::Prest::RequestError) { |error|
            expect(error.headers).to eq(headers)
          }
        end

        it 'assigns the status code to the error' do
          expect { subject }.to raise_error(::Prest::RequestError) { |error|
            expect(error.status).to eq(code)
          }
        end

        it 'assigns the body to the error' do
          expect { subject }.to raise_error(::Prest::RequestError) { |error|
            expect(error.body).to eq(parsed_response.to_json)
          }
        end
      end
    end
  end
end
