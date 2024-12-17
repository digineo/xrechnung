def build_allowance_charge
  Xrechnung::AllowanceCharge.new(
    charge_indicator: false,
    amount:           1,
    base_amount:      1296.30,
  )
end

def build_line_item_allowance_charge
  Xrechnung::AllowanceCharge.new(
    charge_indicator:             false,
    amount:                       1,
    allowance_charge_reason:      "Rabatt",
    allowance_charge_reason_code: 95,
  )
end
