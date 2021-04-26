module Xrechnung
  #     <cbc:ID>S</cbc:ID>
  #     <cbc:Percent>16.00</cbc:Percent>
  #     <cac:TaxScheme>
  #       <cbc:ID>VAT</cbc:ID>
  #     </cac:TaxScheme>
  #
  class TaxCategory
    include MemberContainer

    # @!attribute id
    #   @return [String]
    member :id, type: String

    # @!attribute percent
    #   @return [BigDecimal]
    member :percent, type: BigDecimal, transform_value: ->(v) { BigDecimal(v, 0) }

    # @!attribute tax_scheme_id
    #   @return [String]
    member :tax_scheme_id, type: String

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
