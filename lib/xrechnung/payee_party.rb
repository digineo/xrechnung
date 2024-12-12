module Xrechnung
  # <cac:PayeeParty>
  #   <cac:PartyIdentification>
  #     <cbc:ID schemeID="SEPA">FR932874294</cbc:ID>
  #   </cac:PartyIdentification>
  #   <cac:PartyName>
  #     <cbc:Name>Payee Name Ltd</cbc:Name>
  #   </cac:PartyName>
  # </cac:PayeeParty>
  class PayeeParty
    include MemberContainer

    # @!attribute id
    #   @return [String]
    member :id, type: String

    # @!attribute name
    #   @return [String]
    member :name, type: String, optional: true

    # noinspection RubyResolve
    def to_xml(xml)
      xml.cac :PayeeParty do
        xml.cac :PartyIdentification do
          xml.cbc :ID, id, schemeID: "SEPA"
        end

        if name
          xml.cac :PartyName do
            xml.cbc :Name, name
          end
        end
      end
    end
  end
end
