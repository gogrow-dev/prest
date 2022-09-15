# frozen_string_literal: true

RSpec.describe Prest::RequestError do
  let(:status) { 500 }
  let(:body) { '{ "key": "value" }' }
  let(:headers) { { 'hkey' => 'hvalue' } }
  let(:error) { Prest::RequestError.new(status: status, body: body, headers: headers) }

  describe '#status' do
    subject { error.status }

    it { is_expected.to eq(status) }
  end

  describe '#body' do
    subject { error.body }

    it { is_expected.to eq(body) }
  end

  describe '#headers' do
    subject { error.headers }

    it { is_expected.to eq(headers) }
  end
end
