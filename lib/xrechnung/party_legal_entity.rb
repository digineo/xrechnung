module Xrechnung
  class PartyLegalEntity
    attr_accessor :registration_name

    def to_xml(xml)
      xml.cac :PartyLegalEntity do
        xml.cbc :RegistrationName, registration_name
      end
    end
  end
end
