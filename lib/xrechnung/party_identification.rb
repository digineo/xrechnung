module Xrechnung
  class PartyIdentification
    include MemberContainer

    # @!attribute id
    #   @return [String]
    member :id, type: String

    # @!attribute scheme_id
    #   @return [String]
    member :scheme_id, type: String, optional: true

    # noinspection RubyResolve
    def to_xml(xml)
      xml.cac :PartyIdentification do
        if scheme_id
          xml.cbc :ID, id, schemeID: scheme_id
        else
          xml.cbc :ID, id
        end
      end
    end
  end
end
