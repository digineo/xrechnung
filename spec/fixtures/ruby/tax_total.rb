load("spec/fixtures/ruby/tax_subtotal.rb")

def build_tax_total
  Xrechnung::TaxTotal.new(
    tax_amount:    Xrechnung::Currency::EUR(297.09),
    tax_subtotals: [
      build_tax_subtotal,

      Xrechnung::TaxSubtotal.new(
            taxable_amount: Xrechnung::Currency::EUR(1285.70),
            tax_amount:     Xrechnung::Currency::EUR(90.00),
            tax_category:   Xrechnung::TaxCategory.new(
                id:            "S",
                percent:       7,
                tax_scheme_id: "VAT",
              ),
          ),
    ],
  )
end
