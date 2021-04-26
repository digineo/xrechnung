def build_postal_address
  Xrechnung::PostalAddress.new(
    street_name:            "Beispielgasse 17",
    additional_street_name: "Haus A",
    city_name:              "Baustadt",
    postal_zone:            "12345",
    country_subentity:      "MusterBL",
    country_id:             "DE",
  )
end
