module Xrechnung
  class AllowanceCharge
    include MemberContainer

    # @!attribute charge_indicator
    #   @return [TrueClass, FalseClass]
    member :charge_indicator, type: [TrueClass, FalseClass]

    # @!attribute allowance_charge_reason_code
    #   @return [String]
    member :allowance_charge_reason_code, type: String

    # @!attribute allowance_charge_reason
    #   @return [String]
    member :allowance_charge_reason, type: String

    # @!attribute multiplier_factor_numeric
    #   @return [BigDecimal]
    member :multiplier_factor_numeric, type: BigDecimal, transform_value: ->(v) { BigDecimal(v, 0) }

    # @!attribute amount
    #   @return [Xrechnung::Currency]
    member :amount, type: Xrechnung::Currency

    # @!attribute base_amount
    #   @return [Xrechnung::Currency]
    member :base_amount, type: Xrechnung::Currency, optional: true

    # @!attribute tax_category
    #   @return [Xrechnung::TaxCategory]
    member :tax_category, type: Xrechnung::TaxCategory

    def initialize(**kwargs)
      kwargs[:amount] = Currency::EUR(kwargs[:amount]) unless kwargs[:amount].is_a?(Currency)

      unless kwargs[:base_amount].is_a?(Currency) || kwargs[:base_amount].nil?
        kwargs[:base_amount] = Currency::EUR(kwargs[:base_amount])
      end

      super
    end

    # noinspection RubyResolve
    def to_xml(xml)
      xml.cac :AllowanceCharge do
        xml.cbc :ChargeIndicator, charge_indicator

        xml.cbc :AllowanceChargeReasonCode, allowance_charge_reason_code if allowance_charge_reason_code

        xml.cbc :AllowanceChargeReason, allowance_charge_reason if allowance_charge_reason

        xml.cbc :MultiplierFactorNumeric, format("%.2f", multiplier_factor_numeric) if multiplier_factor_numeric

        xml.cbc :Amount, *amount.xml_args

        xml.cbc :BaseAmount, *base_amount.xml_args if base_amount

        tax_category&.to_xml(xml)
      end
    end
  end
end
