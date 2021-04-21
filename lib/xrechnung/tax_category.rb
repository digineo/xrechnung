module Xrechnung
  #     <cbc:ID>S</cbc:ID>
  #     <cbc:Percent>16.00</cbc:Percent>
  #     <cac:TaxScheme>
  #       <cbc:ID>VAT</cbc:ID>
  #     </cac:TaxScheme>
  #
  TaxCategory = Struct.new(:id, :percent, :tax_scheme_id, keyword_init: true) do
    # noinspection RubyResolve
    def to_xml(xml, root_tag_name: :TaxCategory)
      xml.cac root_tag_name do
        xml.cbc :ID, id
        xml.cbc :Percent, format("%.2f", percent)
        xml.cac :TaxScheme do
          xml.cbc :ID, tax_scheme_id
        end
      end
    end
  end
end
