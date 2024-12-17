module Xrechnung
  #     <cbc:ID>S</cbc:ID>
  #     <cbc:Percent>16.00</cbc:Percent>
  #     <cac:TaxScheme>
  #       <cbc:ID>VAT</cbc:ID>
  #     </cac:TaxScheme>
  #
  class TaxCategory
    include MemberContainer

    # • S (Standard rate)
    # • Z (Zero rated goods)
    # • E (Exempt from tax)
    # • AE (VAT Reverse Charge)
    # • K (VAT exempt for EEA intra-community supply of goods and services)
    # • G (Free export item, tax not charged)
    # • O (Services outside scope of tax)
    # • L (Canary Islands general indirect tax)
    # • M (Tax for production, services and importation in Ceuta and Melilla)
    # @!attribute id
    #   @return [String]
    member :id, type: String

    # @!attribute percent
    #   @return [BigDecimal]
    member :percent, type: BigDecimal, transform_value: ->(v) { v.nil? ? nil : BigDecimal(v, 0) }

    # @!attribute tax_scheme_id
    #   @return [String]
    member :tax_scheme_id, type: String, default: "VAT"

    # @!attribute tax_exemption_reason_code
    #   @return [String]
    member :tax_exemption_reason_code, type: String

    # @!attribute tax_exemption_reason
    #   @return [String]
    member :tax_exemption_reason, type: String

    # noinspection RubyResolve
    def to_xml(xml, root_tag_name: :TaxCategory)
      xml.cac root_tag_name do
        xml.cbc :ID, id
        xml.cbc :Percent, format("%.2f", percent) unless percent.nil?

        unless tax_exemption_reason_code.nil?
          xml.cbc :TaxExemptionReasonCode, tax_exemption_reason_code
          xml.cbc :TaxExemptionReason, tax_exemption_reason
        end

        xml.cac :TaxScheme do
          xml.cbc :ID, tax_scheme_id
        end
      end
    end
  end
end
