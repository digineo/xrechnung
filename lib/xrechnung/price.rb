module Xrechnung
  Price = Struct.new(:price_amount, :base_quantity, :allowance_charge,
                     keyword_init: true) do
    def initialize(**kwargs)
      kwargs[:price_amount] = Currency::EUR(kwargs[:price_amount])
      super(**kwargs)
    end
    # noinspection RubyResolve
    def to_xml(xml)
      xml.cac :Price do
        xml.cbc :PriceAmount, *price_amount.xml_args
        xml.cbc :BaseQuantity, *base_quantity.xml_args
        allowance_charge&.to_xml(xml)
      end
    end
  end
end
