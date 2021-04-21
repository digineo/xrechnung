def build_payee_financial_account
  Xrechnung::PayeeFinancialAccount.new(
    id:                              "DE12500105170648489890",
    name:                            "Harry Hirsch",
    financial_institution_branch_id: "XUFUXHB",
  )
end
