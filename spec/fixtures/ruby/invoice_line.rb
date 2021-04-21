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
