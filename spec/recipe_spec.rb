# -*- encoding : utf-8 -*-

describe Kabuto::Recipe do
  let(:recipe) { Kabuto::Recipe.new }
  let(:page) { double(:page) }
  let(:meta) { Hashie::Mash.new(id: '123', apple: 'green') }

  describe '#initialize' do
    it 'sets values' do
      expect(recipe.items).to eq Hashie::Mash.new
      expect(recipe.nested).to eq false
    end

    it 'initializes with block' do
      recipe = described_class.new do
        foo :css, '.value'
      end

      expect(recipe.items.count).to eq 1
      expect(recipe.items.keys[0]).to eq 'foo'
      expect(recipe.items.values[0].type).to eq :css
      expect(recipe.items.values[0].value).to eq '.value'
    end
  end

  describe '#method_missing' do
    it 'adds normal item' do
      recipe.normal_attr :css, '.value'

      expect(recipe.items.count).to eq 1
      expect(recipe.items.keys[0]).to eq 'normal_attr'
      expect(recipe.items.values[0].type).to eq :css
      expect(recipe.items.values[0].value).to eq '.value'
      expect(recipe.nested?).to eq false
    end

    it 'adds recipe item' do
      recipe.nested_attr do
        another_attribute :xpath, '//test'
      end

      expect(recipe.items.count).to eq 1
      expect(recipe.items.keys[0]).to eq 'nested_attr'
      expect(recipe.items.values[0].type).to eq :recipe
      expect(recipe.items.values[0].value).to be_a Kabuto::Recipe
      expect(recipe.nested?).to eq true
    end
  end

  describe '#process' do
    let(:items) do
      Hashie::Mash.new(
        foo: double('item'),
        bar: double('item'),
      )
    end

    it 'returns correct value' do
      items.each do |_, item|
        expect(item).to receive(:process).with(page, meta)
      end

      expect(recipe).to receive(:items).and_return(items)
      result = recipe.process(page, meta)
      expect(result).to be_a Hashie::Mash
    end
  end
end
