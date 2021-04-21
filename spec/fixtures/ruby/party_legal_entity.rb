def build_party_legal_entity
  party_legal_entity                   = Xrechnung::PartyLegalEntity.new
  party_legal_entity.registration_name = "Harry Hirsch Holz- und Trockenbau"
  party_legal_entity
end
