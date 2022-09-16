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

    # @!attribute instruction_note
    #   @return [String]
    member :instruction_note, type: String

    # @!attribute payment_id
    #   @return [String]
    member :payment_id, type: String


    # @!attribute payee_financial_account
    #   @return [Xrechnung::PayeeFinancialAccount]
    member :payee_financial_account, type: Xrechnung::PayeeFinancialAccount

    # noinspection RubyResolve
    def to_xml(xml)
      xml.cbc :PaymentMeansCode, payment_means_code
      xml.cbc :InstructionNote, instruction_note
      xml.cbc :PaymentID, payment_id
      payee_financial_account&.to_xml(xml)
    end
  end
end
