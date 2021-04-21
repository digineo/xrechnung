module Xrechnung
  AllowanceCharge = Struct.new(:charge_indicator, :amount, :base_amount,
    keyword_init: true) do
    def initialize(**kwargs)
      kwargs[:amount] = Currency::EUR(kwargs[:amount])
      kwargs[:base_amount] = Currency::EUR(kwargs[:base_amount])
      super(**kwargs)
    end

    # noinspection RubyResolve
    def to_xml(xml)
      xml.cac :AllowanceCharge do
        xml.cbc :ChargeIndicator, charge_indicator
        xml.cbc :Amount, *amount.xml_args
        xml.cbc :BaseAmount, *base_amount.xml_args
      end
    end
  end
end
