def build_legal_monetary_total
  Xrechnung::LegalMonetaryTotal.new(
    line_extension_amount:   2580,
    tax_exclusive_amount:    2580,
    tax_inclusive_amount:    2877.09,
    allowance_total_amount:  Xrechnung::Currency::EUR(0),
    charge_total_amount:     0,
    prepaid_amount:          0,
    payable_rounding_amount: 0,
    payable_amount:          2877.09,
  )
end
