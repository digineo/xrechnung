load("spec/fixtures/ruby/allowance_charge.rb")

def build_price
  Xrechnung::Price.new(
    price_amount:     1295.30,
    base_quantity:    Xrechnung::Quantity.new(1, "XPP"),
    allowance_charge: build_allowance_charge,
  )
end
