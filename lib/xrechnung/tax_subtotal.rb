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
  class TaxSubtotal
    include MemberContainer

    # @!attribute taxable_amount
    #   @return [Xrechnung::Currency]
    member :taxable_amount, type: Xrechnung::Currency

    # @!attribute tax_amount
    #   @return [Xrechnung::Currency]
    member :tax_amount, type: Xrechnung::Currency

    # @!attribute tax_category
    #   @return [Xrechnung::TaxCategory]
    member :tax_category, type: Xrechnung::TaxCategory

    # @!attribute taxable_amount
    #   @return [Xrechnung::Currency]

    def initialize(*args)
      super
      self.taxable_amount ||= Currency::EUR(0)
    end

    # noinspection RubyResolve
    def to_xml(xml)
      xml.cac :TaxSubtotal do
        xml.cbc :TaxableAmount, *taxable_amount.xml_args
        xml.cbc :TaxAmount, *tax_amount.xml_args
        tax_category&.to_xml(xml)
      end
    end
  end
end
