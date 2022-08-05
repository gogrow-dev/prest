# frozen_string_literal: true

RSpec.shared_examples 'forwards methods to httparty\'s response' do
  it 'allows access to the status' do
    expect(subject.status).to eq(code)
  end

  it 'allows access to the body' do
    expect(subject.body).to eq(parsed_response)
  end

  it 'allows access to the headers' do
    expect(subject.headers).to eq(headers)
  end

  it 'allows access direct access the parsed response data' do
    expect(subject[:key]).to eq('value')
  end
end
