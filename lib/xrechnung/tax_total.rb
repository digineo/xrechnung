module Xrechnung
  # <cbc:TaxAmount currencyID="EUR">297.09</cbc:TaxAmount>
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
  # <cac:TaxSubtotal>
  #   <cbc:TaxableAmount currencyID="EUR">1285.70</cbc:TaxableAmount>
  #   <cbc:TaxAmount currencyID="EUR">90.00</cbc:TaxAmount>
  #   <cac:TaxCategory>
  #     <cbc:ID>S</cbc:ID>
  #     <cbc:Percent>7.00</cbc:Percent>
  #     <cac:TaxScheme>
  #       <cbc:ID>VAT</cbc:ID>
  #     </cac:TaxScheme>
  #   </cac:TaxCategory>
  # </cac:TaxSubtotal>
  #
  class TaxTotal
    include MemberContainer

    # @!attribute tax_amount
    #   @return [Xrechnung::Currency]
    member :tax_amount, type: Xrechnung::Currency

    # @!attribute tax_subtotals
    #   @return [Array]
    member :tax_subtotals, type: Array, default: []

    # noinspection RubyResolve
    def to_xml(xml)
      xml.cbc :TaxAmount, *tax_amount.xml_args
      tax_subtotals.each do |tax_subtotal|
        tax_subtotal&.to_xml(xml)
      end
      xml.target!
    end

    def update_amounts
      value           = tax_subtotals.sum(&:update_amount)
      self.tax_amount = Xrechnung::Currency::EUR(value)
    end

    def get_tax_subtotal(tax_category)
      element = tax_subtotals.find { _1.tax_category == tax_category }

      unless element
        element = Xrechnung::TaxSubtotal.new(tax_category: tax_category)
        tax_subtotals << element
      end

      element
    end
  end
end
