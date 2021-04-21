module Xrechnung
  PartyLegalEntity = Struct.new(:registration_name, keyword_init: true) do
    # noinspection RubyResolve
    def to_xml(xml)
      xml.cac :PartyLegalEntity do
        xml.cbc :RegistrationName, registration_name
      end
    end
  end
end
