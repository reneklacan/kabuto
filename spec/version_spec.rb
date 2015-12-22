# -*- encoding : utf-8 -*-

describe Kabuto do
  it 'defines version in correct format' do
    expect(Kabuto::VERSION).to match(/^\d+\.\d+\.\d+$/)
  end
end
