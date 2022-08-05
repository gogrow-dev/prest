# frozen_string_literal: true

RSpec.shared_examples 'returns a correct response' do
  it 'returns a Prest::Response' do
    expect(subject).to be_a(Prest::Response)
  end

  it 'returns a successful response' do
    expect(subject.successful?).to eq(true)
  end

  context 'when the response is not successful with error code 400s' do
    let!(:code) { 400 }

    it 'returns a Prest::Response' do
      expect(subject).to be_a(Prest::Response)
    end

    it 'returns a unsuccessful response' do
      expect(subject.successful?).to eq(false)
    end
  end

  context 'when the response is not successful with error code 500s' do
    let!(:code) { 500 }

    it 'returns a Prest::Response' do
      expect(subject).to be_a(Prest::Response)
    end

    it 'returns a unsuccessful response' do
      expect(subject.successful?).to eq(false)
    end
  end
end
