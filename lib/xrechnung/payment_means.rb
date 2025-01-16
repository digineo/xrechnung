module Xrechnung
  # <cac:PaymentMeans>
  #   <cbc:PaymentMeansCode>30</cbc:PaymentMeansCode>
  #   <cbc:InstructionNote>Textvermerk der Zahlung</cbc:InstructionNote>
  #   <cbc:PaymentID>Verwendungszweck</cbc:PaymentID>
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

    # Payment means type code BT-81
    #
    # @!attribute payment_means_code
    #   @return [Integer]
    member :payment_means_code, type: Integer

    # Payment means text BT-82
    #
    # @!attribute payment_means_code
    #   @return [String]
    member :instruction_note, type: String, optional: true

    # Remittance information BT-83
    #
    # @!attribute payment_means_code
    #   @return [String]
    member :payment_id, type: String, optional: true

    # Credit transfer BG-17
    #
    # @!attribute payee_financial_account
    #   @return [Xrechnung::PayeeFinancialAccount]
    member :payee_financial_account, type: Xrechnung::PayeeFinancialAccount

    # Direct debit BG-19
    #
    # @!attribute payment_mandate
    #   @return [Xrechnung::PaymentMandate]
    member :payment_mandate, type: Xrechnung::PaymentMandate, optional: true

    # noinspection RubyResolve
    def to_xml(xml)
      xml.cbc :PaymentMeansCode, payment_means_code
      xml.cbc :InstructionNote, instruction_note if instruction_note
      xml.cbc :PaymentID, payment_id if payment_id
      payee_financial_account&.to_xml(xml)
      payment_mandate&.to_xml(xml)
      xml.target!
    end
  end
end
