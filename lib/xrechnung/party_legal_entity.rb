module Xrechnung
  class PartyLegalEntity
    include MemberContainer

    # @!attribute registration_name
    #   @return [String]
    member :registration_name, type: String

    # noinspection RubyResolve
    def to_xml(xml)
      xml.cac :PartyLegalEntity do
        xml.cbc :RegistrationName, registration_name
      end
    end
  end
end
