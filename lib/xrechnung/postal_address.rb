module Xrechnung
  class PostalAddress
    include MemberContainer

    # @!attribute street_name
    #   @return [String]
    member :street_name, type: String

    # @!attribute additional_street_name
    #   @return [String]
    member :additional_street_name, type: String

    # @!attribute city_name
    #   @return [String]
    member :city_name, type: String

    # @!attribute postal_zone
    #   @return [String]
    member :postal_zone, type: String

    # @!attribute country_subentity
    #   @return [String]
    member :country_subentity, type: String

    # @!attribute country_id
    #   @return [String]
    member :country_id, type: String

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
