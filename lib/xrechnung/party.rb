module Xrechnung
  class Party
    attr_accessor :postal_address, :party_tax_scheme, :party_legal_entity, :contact

    def to_xml(xml)
      xml.cac :Party do
        postal_address&.to_xml(xml)
        party_tax_scheme&.to_xml(xml)
        party_legal_entity&.to_xml(xml)
        contact&.to_xml(xml)

        # xml.cac :PartyName do
        #   xml.cbc :Name, name
        # end
      end
    end
  end
end
