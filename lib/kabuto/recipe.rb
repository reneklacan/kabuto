# -*- encoding : utf-8 -*-

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
      if @params[:each]
        page.xpath(@params[:each]).map{ |n| process_one(n, meta) }
      elsif @params[:each_css]
        page.css(@params[:each_css]).map{ |n| process_one(n, meta) }
      else
        process_one(page, meta)
      end
    end

    def process_one node, meta = nil
      result = Hashie::Mash.new

      items.each do |name, item|
        result[name] = item.process(node, meta)
      end

      result
    end

    def nested?
      @nested
    end
  end

end
