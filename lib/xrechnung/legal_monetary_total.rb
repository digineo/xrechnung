module Xrechnung
  class LegalMonetaryTotal
    include MemberContainer

    transform_currency = ->(v) {
      v.is_a?(Currency) ? v : Currency::EUR(v)
    }

    # @!attribute line_extension_amount
    #   @return [Xrechnung::Currency]
    member :line_extension_amount, type: Xrechnung::Currency, transform_value: transform_currency

    # @!attribute tax_exclusive_amount
    #   @return [Xrechnung::Currency]
    member :tax_exclusive_amount, type: Xrechnung::Currency, transform_value: transform_currency

    # @!attribute tax_inclusive_amount
    #   @return [Xrechnung::Currency]
    member :tax_inclusive_amount, type: Xrechnung::Currency, transform_value: transform_currency

    # @!attribute allowance_total_amount
    #   @return [Xrechnung::Currency]
    member :allowance_total_amount, type: Xrechnung::Currency, transform_value: transform_currency

    # @!attribute charge_total_amount
    #   @return [Xrechnung::Currency]
    member :charge_total_amount, type: Xrechnung::Currency, transform_value: transform_currency

    # @!attribute prepaid_amount
    #   @return [Xrechnung::Currency]
    member :prepaid_amount, type: Xrechnung::Currency, transform_value: transform_currency

    # @!attribute payable_rounding_amount
    #   @return [Xrechnung::Currency]
    member :payable_rounding_amount, type: Xrechnung::Currency, transform_value: transform_currency

    # @!attribute payable_amount
    #   @return [Xrechnung::Currency]
    member :payable_amount, type: Xrechnung::Currency, transform_value: transform_currency

    # noinspection RubyResolve
    def to_xml(xml)
      self.class.members.each_key do |name|
        next if self[name].nil?

        xml.cbc :"#{name.to_s.split("_").map(&:capitalize).join}", *self[name].xml_args
      end
      xml.target!
    end
  end
end
