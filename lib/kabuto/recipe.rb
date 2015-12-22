# -*- encoding : utf-8 -*-
require 'kabuto/recipe_item'

module Kabuto

  class Recipe
    attr_reader :items, :params, :nested

    def initialize params={}, &block
      @params = Hashie::Mash.new(params)
      @items = Hashie::Mash.new
      @nested = false

      instance_eval(&block) if block_given?
    end

    def method_missing name, *args, &block
      if block_given?
        recipe = Recipe.new
        recipe.instance_eval(&block)
        @items[name] = RecipeItem.new(:recipe, recipe)
        @nested = true
      else
        type, value, convert_to = args[0..2]
        @items[name] = RecipeItem.new(type, value, convert_to)
      end
    end

    def process page, meta = nil
      result = Hashie::Mash.new

      items.each do |name, item|
        result[name] = item.process(page, meta)
      end

      result
    end

    def nested?
      @nested
    end
  end

end
