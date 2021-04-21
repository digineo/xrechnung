def build_tax_category
  Xrechnung::TaxCategory.new(
    id:            "S",
    percent:       16,
    tax_scheme_id: "VAT",
  )
end
