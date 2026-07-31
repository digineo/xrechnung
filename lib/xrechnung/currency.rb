require "bigdecimal"
require "bigdecimal/util"

module Xrechnung
  Currency = Struct.new(:currency_id, :value, keyword_init: true) do
    def value_to_s
      format("%0.2f", value)
    end

    def xml_args
      [value_to_s, { currencyID: currency_id }]
    end

    def self.check_matching_attributes(one, other)
      raise ArgumentError, "other must be a Currency" unless one.is_a? Currency
      raise ArgumentError, "other must be a Currency" unless other.is_a? Currency
      raise ArgumentError, "currency_id must match" unless one.currency_id == other.currency_id
    end

    def +(other)
      self.class.check_matching_attributes(self, other)
      Currency.new(currency_id: currency_id, value: value + other.value)
    end

    def -(other)
      self.class.check_matching_attributes(self, other)
      Currency.new(currency_id: currency_id, value: value - other.value)
    end
  end

  class << Currency
    def EUR(value)
      raise ArgumentError, "value must respond to :to_d" unless value.respond_to? :to_d

      Currency.new(currency_id: "EUR", value: value.to_d)
    end
  end
end
