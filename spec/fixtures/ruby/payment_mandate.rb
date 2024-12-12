def build_payment_mandate
  Xrechnung::PaymentMandate.new(
    id: "SEPA-MANDAT-123",
    payer_financial_account_id: "DE02500105170137075030",
  )
end
