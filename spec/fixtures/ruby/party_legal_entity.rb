def build_party_legal_entity(company_id: nil)
  Xrechnung::PartyLegalEntity.new(
    company_id:        company_id,
    registration_name: "Harry Hirsch Holz- und Trockenbau",
  )
end
