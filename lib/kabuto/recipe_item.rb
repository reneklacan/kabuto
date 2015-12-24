# -*- encoding : utf-8 -*-

module Kabuto

  class RecipeItem
    TYPES = [:var, :recipe, :css, :xpath, :lambda, :proc, :const, :static]

    attr_reader :type, :value

    def initialize type, value, convert_to=nil
      raise "Unknown recipe item type '#{type}'" unless TYPES.include?(type.to_sym)

      @type = type.to_sym
      @value = value
      @convert_to = convert_to
    end

    def process page, meta
      convert(get(page, Hashie::Mash.new(meta)))
    end

    protected

    def get page, meta
      case type
      when :var
        meta[value]
      when :recipe
        value.process(page, meta)
      when :css
        page.css(value).text.gsub(/\u00a0/, ' ').strip
      when :xpath
        page.xpath(value).text.gsub(/\u00a0/, ' ').strip
      when :lambda, :proc
        Module.new.instance_exec([page, meta], &value)
      when :const
        value
      end
    end

    def convert v
      return nil if v.nil?

      case @convert_to
      when nil then v
      when :int then v[/\d+/].to_i
      when :float then v.gsub(',', '.')[/\d+(\.\d+)?/].to_f
      when :date then Date.parse(v).iso8601
      else raise "Unknown conversion type '#{@convert_to}'"
      end
    end
  end

end
