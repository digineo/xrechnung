module Xrechnung
  InvoiceLine = Struct.new(:id, :invoiced_quantity, :line_extension_amount,
    :item, :price, keyword_init: true) do
    def initialize(**kwargs)
      kwargs[:line_extension_amount] = Currency::EUR(kwargs[:line_extension_amount])
      super(**kwargs)
    end

    # noinspection RubyResolve
    def to_xml(xml)
      xml.cac :InvoiceLine do
        xml.cbc :ID, id
        xml.cbc :InvoicedQuantity, invoiced_quantity.amount_to_s, unitCode: invoiced_quantity.unit_code
        xml.cbc :LineExtensionAmount, *line_extension_amount.xml_args
        item&.to_xml(xml)
        price&.to_xml(xml)
      end
    end
  end
end
