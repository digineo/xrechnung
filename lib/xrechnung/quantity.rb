module Xrechnung
  Quantity = Struct.new(:amount, :unit_code) do
    def amount_to_s
      format("%0.2f", amount)
    end

    def xml_args
      [amount_to_s, { unitCode: unit_code }]
    end
  end
end
