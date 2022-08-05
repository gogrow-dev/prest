# frozen_string_literal: true

RSpec.describe Prest::VERSION do
  it 'has a version number' do
    expect(Prest::VERSION).not_to eq(nil)
  end
end
