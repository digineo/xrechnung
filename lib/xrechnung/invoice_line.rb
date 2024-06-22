require "xrechnung/invoice_period"

module Xrechnung
  class InvoiceLine
    include MemberContainer

    # @!attribute id
    #   @return [Integer]
    member :id, type: Integer

    # @!attribute invoiced_quantity
    #   @return [Xrechnung::Quantity]
    member :invoiced_quantity, type: Xrechnung::Quantity

    # @!attribute line_extension_amount
    #   @return [Xrechnung::Currency]
    member :line_extension_amount, type: Xrechnung::Currency

    # @!attribute invoice_period
    #   @return [Xrechnung::InvoicePeriod]
    member :invoice_period, type: Xrechnung::InvoicePeriod, optional: true

    # @!attribute item
    #   @return [Xrechnung::Item]
    member :item, type: Xrechnung::Item

    # @!attribute price
    #   @return [Xrechnung::Price]
    member :price, type: Xrechnung::Price

    def initialize(**kwargs)
      unless kwargs[:line_extension_amount].is_a?(Currency)
        kwargs[:line_extension_amount] = Currency::EUR(kwargs[:line_extension_amount])
      end
      super(**kwargs)
    end

    # noinspection RubyResolve
    def to_xml(xml)
      xml.cac :InvoiceLine do
        xml.cbc :ID, id
        xml.cbc :InvoicedQuantity, invoiced_quantity.amount_to_s, unitCode: invoiced_quantity.unit_code
        xml.cbc :LineExtensionAmount, *line_extension_amount.xml_args

        unless self.class.members[:invoice_period].optional && invoice_period.nil?
          invoice_period&.to_xml(xml)
        end
        item&.to_xml(xml)
        price&.to_xml(xml)
      end
    end
  end
end
