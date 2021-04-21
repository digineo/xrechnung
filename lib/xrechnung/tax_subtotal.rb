module Xrechnung
  # <cac:TaxSubtotal>
  #   <cbc:TaxableAmount currencyID="EUR">1294.30</cbc:TaxableAmount>
  #   <cbc:TaxAmount currencyID="EUR">207.09</cbc:TaxAmount>
  #   <cac:TaxCategory>
  #     <cbc:ID>S</cbc:ID>
  #     <cbc:Percent>16.00</cbc:Percent>
  #     <cac:TaxScheme>
  #       <cbc:ID>VAT</cbc:ID>
  #     </cac:TaxScheme>
  #   </cac:TaxCategory>
  # </cac:TaxSubtotal>
  #
  #
  TaxSubtotal = Struct.new(:taxable_amount, :tax_amount, :tax_category, keyword_init: true) do
    # @!attribute taxable_amount
    #   @return [Xrechnung::Currency]

    def initialize(*args)
      super
      self.taxable_amount ||= Currency::EUR(0)
    end

    # noinspection RubyResolve
    def to_xml(xml)
      xml.cac :TaxSubtotal do
        xml.cbc :TaxableAmount, taxable_amount.value_to_s, currencyID: taxable_amount.currency_code
        xml.cbc :TaxAmount, tax_amount.value_to_s, currencyID: tax_amount.currency_code
        tax_category&.to_xml(xml)
      end
    end
  end
end
