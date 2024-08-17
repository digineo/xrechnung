module Xrechnung
  class AllowanceCharge
    include MemberContainer

    # @!attribute charge_indicator
    #   @return [TrueClass, FalseClass]
    member :charge_indicator, type: [TrueClass, FalseClass]

    # @!attribute allowance_charge_reason_code
    #   @return [String]
    member :allowance_charge_reason_code, type: Integer

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
    member :base_amount, type: Xrechnung::Currency

    # @!attribute tax_category
    #   @return [Xrechnung::TaxCategory]
    member :tax_category, type: Xrechnung::TaxCategory

    def initialize(**kwargs)
      unless kwargs[:amount].is_a?(Currency)
        kwargs[:amount] = Currency::EUR(kwargs[:amount])
      end

      unless kwargs[:base_amount].is_a?(Currency)
        kwargs[:base_amount] = Currency::EUR(kwargs[:base_amount])
      end

      super(**kwargs)
    end

    # noinspection RubyResolve
    def to_xml(xml)
      xml.cac :AllowanceCharge do
        xml.cbc :ChargeIndicator, charge_indicator

        if allowance_charge_reason_code
          xml.cbc :AllowanceChargeReasonCode, allowance_charge_reason_code
        end

        if allowance_charge_reason
          xml.cbc :AllowanceChargeReason, allowance_charge_reason
        end

        if multiplier_factor_numeric
          xml.cbc :MultiplierFactorNumeric, format("%.2f", multiplier_factor_numeric)
        end

        xml.cbc :Amount, *amount.xml_args
        xml.cbc :BaseAmount, *base_amount.xml_args

        tax_category&.to_xml(xml)
      end
    end
  end
end
