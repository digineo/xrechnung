module Xrechnung
  class PartyLegalEntity
    include MemberContainer

    # @!attribute company_id
    #   @return [String]
    member :company_id, type: String

    # @!attribute registration_name
    #   @return [String]
    member :registration_name, type: String

    # noinspection RubyResolve
    def to_xml(xml)
      xml.cac :PartyLegalEntity do
        xml.cbc :RegistrationName, registration_name
        xml.cbc(:CompanyID, company_id) unless company_id.nil?
      end
    end
  end
end
