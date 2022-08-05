# frozen_string_literal: true

class MockService < Prest::Service
  def base_uri
    'https://api.example.com'
  end

  def options
    {
      headers: {
        'custom_header' => 'my_value'
      }
    }
  end
end

RSpec.describe 'Prest::Service' do
  before do
    %i[get post put patch delete].each do |http_method|
      allow(HTTParty).to receive(http_method).and_return(double(:response, body: '{}'))
    end

    # Add #fragments and #query_params to the instance of Prest::Client only in the tests.
    Prest::Client.class_eval { attr_reader :fragments, :base_uri, :options }
  end

  describe 'method chaining on instance' do
    let(:base_uri) { 'https://api.example.com' }
    let(:test_service) { MockService.new }

    subject { test_service.fragment1.fragment2.fragment3 }

    it 'forwards all te method_missing calls to Prest::Client' do
      expect(subject).to be_a(Prest::Client)
    end

    it 'returns a new valid instance of Prest::Client' do
      expect(subject.fragments).to eq(%w[fragment1/ fragment2/ fragment3/])
      expect(subject.base_uri).to eq(base_uri)
      expect(subject.options).to eq({
                                      headers: {
                                        'custom_header' => 'my_value'
                                      }
                                    })
    end

    it 'responds to all possible singleton_methods' do
      expect(MockService.respond_to_missing?(:method, :param)).to eq(true)
    end

    it 'responds to all possible instance methods' do
      expect(MockService.new.respond_to_missing?(:method, :param)).to eq(true)
    end
  end

  describe 'method chaining class' do
    let(:base_uri) { 'https://api.example.com' }
    let(:test_service) { MockService }

    subject { test_service.fragment1.fragment2.fragment3 }

    it 'forwards all te method_missing calls to Prest::Client' do
      expect(subject).to be_a(Prest::Client)
    end

    it 'returns a new valid instance of Prest::Client' do
      expect(subject.fragments).to eq(%w[fragment1/ fragment2/ fragment3/])
      expect(subject.base_uri).to eq(base_uri)
      expect(subject.options).to eq({
                                      headers: {
                                        'custom_header' => 'my_value'
                                      }
                                    })
    end

    it 'responds to all possible singleton_methods' do
      expect(MockService.respond_to_missing?(:method, :param)).to eq(true)
    end

    it 'responds to all possible instance methods' do
      expect(MockService.new.respond_to_missing?(:method, :param)).to eq(true)
    end
  end

  describe '#base_uri' do
    subject { ::Prest::Service.new.example }

    it 'raises an exeption' do
      expect { subject }.to raise_error(::Prest::Error)
    end
  end

  describe '#options' do
    before do
      ::Prest::Service.class_eval do
        def base_uri
          'https://api.example.com'
        end
      end
    end

    it 'raises an exeption' do
      expect(::Prest::Service.__send__(:options)).to eq({})
    end
  end
end
