def build_party_tax_scheme
  party_tax_scheme               = Xrechnung::PartyTaxScheme.new
  party_tax_scheme.company_id    = "DE 214365879"
  party_tax_scheme.tax_scheme_id = "VAT"
  party_tax_scheme
end
