module Xrechnung
  PostalAddress = Struct.new(:street_name, :additional_street_name, :city_name,
    :postal_zone, :country_subentity, :country_id, keyword_init: true) do
    # noinspection RubyResolve
    def to_xml(xml)
      xml.cac :PostalAddress do
        xml.cbc :StreetName, street_name if street_name
        xml.cbc :AdditionalStreetName, additional_street_name if additional_street_name
        xml.cbc :CityName, city_name if city_name
        xml.cbc :PostalZone, postal_zone if postal_zone
        xml.cbc :CountrySubentity, country_subentity if country_subentity

        xml.cac :Country do
          xml.cbc :IdentificationCode, country_id
        end
      end
    end
  end
end
