def build_allowance_charge
  Xrechnung::AllowanceCharge.new(
    charge_indicator: false,
    amount:           1,
    base_amount:      1295.30,
  )
end
