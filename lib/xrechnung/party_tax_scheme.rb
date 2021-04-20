module Xrechnung
  class PartyTaxScheme
    attr_accessor :company_id, :tax_scheme_id

    def to_xml(xml)
      xml.cac :PartyTaxScheme do
        xml.cbc :CompanyID, company_id
        xml.cac :TaxScheme do
          xml.cbc :ID, tax_scheme_id
        end
      end
    end
  end
end
