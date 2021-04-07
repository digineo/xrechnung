require "xrechnung/version"
require "builder"

module Xrechnung
  class Error < StandardError; end

  class Document

    attr_accessor :id, :issue_date, :due_date, \
      :invoice_type_code, :document_currency_code, :note,
      :order_reference_id

    attr_accessor :supplier, :customer

    def initialize
      self.invoice_type_code      = 380
      self.document_currency_code = "EUR"
    end

    def to_xml(indent: 2, target: "")
      xml = Builder::XmlMarkup.new(indent: indent, target: target)
      xml.instruct! :xml, version: "1.0", encoding: "UTF-8"

      xml.Invoice \
        "xmlns:cac" => "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2",
        "xmlns:cbc" => "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2",
        "xmlns" => "urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" do
        xml.cbc :CustomizationID, "urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0"
        xml.cbc :ProfileID, "urn:fdc:peppol.eu:2017:poacc:billing:01:1.0"
        xml.cbc :ID, id
        xml.cbc :IssueDate, issue_date
        xml.cbc :DueDate, due_date
        xml.cbc :InvoiceTypeCode, invoice_type_code
        xml.cbc :DocumentCurrencyCode, document_currency_code
        xml.cbc :Note, note

        xml.cac :OrderReference do
          xml.cbc :ID, order_reference_id
        end

        xml.cac :AccountingSupplierParty do
          supplier&.to_xml(xml)
        end
        xml.cac :AccountingCustomerParty do
          customer&.to_xml(xml)
        end
      end

      target
    end

  end


  class Party
    attr_accessor :name

    def to_xml(xml)
      xml.cac :Party do
        xml.cac :PartyName do
          xml.cbc :Name, name
        end
      end
    end
  end

end
