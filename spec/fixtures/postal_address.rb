def build_postal_address
  postal_address                        = Xrechnung::PostalAddress.new
  postal_address.street_name            = "Beispielgasse 17"
  postal_address.additional_street_name = "Haus A"
  postal_address.city_name              = "Baustadt"
  postal_address.postal_zone            = 12_345
  postal_address.country_subentity      = "MusterBL"
  postal_address.country_id             = "DE"
  postal_address
end
