module Xrechnung
  class PartyLegalEntity
    include MemberContainer

    # @!attribute registration_name
    #   @return [String]
    member :registration_name, type: String

    # @!attribute company_id
    #   @return [String]
    member :company_id, type: String

    # noinspection RubyResolve
    def to_xml(xml)
      xml.cac :PartyLegalEntity do
        xml.cbc :RegistrationName, registration_name
        xml.cbc :CompanyID, company_id
      end
    end
  end
end
