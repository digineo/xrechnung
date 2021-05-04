module Xrechnung
  class PartyIdentification
    include MemberContainer

    # @!attribute id
    #   @return [String]
    member :id, type: String

    # noinspection RubyResolve
    def to_xml(xml)
      xml.cac :PartyIdentification do
        xml.cbc :ID, id
      end
    end
  end
end
