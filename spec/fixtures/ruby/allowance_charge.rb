def build_allowance_charge
  Xrechnung::AllowanceCharge.new(
    charge_indicator: true,
    amount:           0,
    base_amount:      1294.30,
  )
end
