module Xrechnung
  class LegalMonetaryTotal
    include MemberContainer

    transform_currency = ->(v) {
      Currency::EUR(v)
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
      members.each do |member, _options|
        next if self[member].nil?

        xml.cbc :"#{member.to_s.split("_").map(&:capitalize).join}", *self[member].xml_args
      end
      xml.target!
    end
  end
end
