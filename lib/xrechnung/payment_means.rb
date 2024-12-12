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
  class PaymentMeans
    include MemberContainer

    # @!attribute payment_means_code
    #   @return [Integer]
    member :payment_means_code, type: Integer

    # @!attribute payee_financial_account
    #   @return [Xrechnung::PayeeFinancialAccount]
    member :payee_financial_account, type: Xrechnung::PayeeFinancialAccount

    # @!attribute payment_mandate
    #   @return [Xrechnung::PaymentMandate]
    member :payment_mandate, type: Xrechnung::PaymentMandate, optional: true

    # noinspection RubyResolve
    def to_xml(xml)
      xml.cbc :PaymentMeansCode, payment_means_code
      payee_financial_account&.to_xml(xml)
      payment_mandate&.to_xml(xml)
      xml.target!
    end
  end
end
