module Xrechnung
  class Delivery
    include MemberContainer
    #
    # @!attribute actual_delivery_date
    #   @return [String]
    member :actual_delivery_date, type: Date

    # @!attribute party_name
    #   @return [String]
    member :party_name, type: String

    # @!attribute city_name
    #   @return [String]
    member :city_name, type: String

    # @!attribute postal_zone
    #   @return [String]
    member :postal_zone, type: String

    # noinspection RubyResolve
    def to_xml(xml)
      xml.cac :Delivery do
        xml.cbc :ActualDeliveryDate, actual_delivery_date unless actual_delivery_date.nil?
        if city_name.present? || postal_zone.present?
          xml.cac :DeliveryLocation do
            xml.cac :Address do
              xml.cbc :CityName, city_name unless city_name.nil?
              xml.cbc :PostalZone, postal_zone unless postal_zone.nil?
              xml.cac :Country do
                xml.cbc :IdentificationCode, "DE"
              end
            end
          end
        end
        if party_name.present?
          xml.cac :DeliveryParty do
            xml.cac :PartyName do
              xml.cbc :Name, party_name
            end
          end
        end
      end
    end
  end
end
