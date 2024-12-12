module Xrechnung
  # <cac:PaymentMandate>
  #    <cbc:ID>SEPA-MANDAT-123</cbc:ID>
  #    <cac:PayerFinancialAccount>
  #      <cbc:ID>DE02500105170137075030</cbc:ID>
  #    </cac:PayerFinancialAccount>
  # </cac:PaymentMandate>
  class PaymentMandate
    include MemberContainer

    # @!attribute id
    #   @return [String]
    member :id, type: String

    # @!attribute payer_financial_account_id
    #   @return [String]
    member :payer_financial_account_id, type: String

    # noinspection RubyResolve
    def to_xml(xml)
      xml.cac :PaymentMandate do
        xml.cbc :ID, id
        xml.cac :PayerFinancialAccount do
          xml.cbc :ID, payer_financial_account_id
        end
      end
    end
  end
end
