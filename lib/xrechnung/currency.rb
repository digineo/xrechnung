require "bigdecimal"
require "bigdecimal/util"

module Xrechnung
  Currency = Struct.new(:currency_code, :value, keyword_init: true) do
    def value_to_s
      format("%0.2f", value)
    end
  end

  class << Currency
    def EUR(value)
      raise ArgumentError, "value must respond to :to_d" unless value.respond_to? :to_d

      Currency.new(currency_code: "EUR", value: value.to_d)
    end
  end
end
