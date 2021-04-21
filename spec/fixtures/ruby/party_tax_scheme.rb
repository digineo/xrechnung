def build_party_tax_scheme
  Xrechnung::PartyTaxScheme.new(
    company_id:    "DE 214365879",
    tax_scheme_id: "VAT",
  )
end
