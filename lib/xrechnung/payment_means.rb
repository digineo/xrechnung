module Xrechnung
  # <cac:PaymentMeans>
  #   <cbc:PaymentMeansCode>30</cbc:PaymentMeansCode>
  #   <cac:PayeeFinancialAccount>
  #     <cbc:ID>DE12500105170648489890</cbc:ID>
  #     <cbc:Name>Harry Hirsch</cbc:Name>
  #     <cac:FinancialInstitutionBranch>
  #       <cbc:ID>XUFUXHB</cbc:ID>
  #     </cac:FinancialInstitutionBranch>
  #   </cac:PayeeFinancialAccount>
  # </cac:PaymentMeans>
  PaymentMeans = Struct.new(:payment_means_code, :payee_financial_account, keyword_init: true) do
    # noinspection RubyResolve
    def to_xml(xml)
      xml.cbc :PaymentMeansCode, payment_means_code
      payee_financial_account&.to_xml(xml)
    end
  end
end
