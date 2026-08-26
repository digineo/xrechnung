load("spec/fixtures/ruby/item.rb")
load("spec/fixtures/ruby/price.rb")

def build_invoice_line
  Xrechnung::InvoiceLine.new(
    id:                    0,
    invoiced_quantity:     Xrechnung::Quantity.new(1, "XPP"),
    line_extension_amount: 1294.30,
    item:                  build_item,
    price:                 build_price,
  )
end

def build_invoice_line_with_allowance_charge
  Xrechnung::InvoiceLine.new(
    id:                    0,
    invoiced_quantity:     Xrechnung::Quantity.new(1, "XPP"),
    line_extension_amount: 1294.30,
    item:                  build_item,
    price:                 build_price,
    allowance_charges:     [build_line_item_allowance_charge],
  )
end

def build_invoice_line_with_item_with_exempt_tax_category
  Xrechnung::InvoiceLine.new(
    id:                    0,
    invoiced_quantity:     Xrechnung::Quantity.new(1, "XPP"),
    line_extension_amount: 1294.30,
    item:                  build_item_with_exempt_tax_category,
    price:                 build_price,
  )
end
