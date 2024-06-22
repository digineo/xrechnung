def build_tax_category(exempt: false)
  category = Xrechnung::TaxCategory.new(
    id:            "S",
    percent:       16,
    tax_scheme_id: "VAT",
  )

  return category unless exempt

  category.tax_exemption_reason_code = "VATEX-EU-S"
  category.tax_exemption_reason      = "Exempt"

  category
end
