require "xrechnung/version"
require "xrechnung/party"
require "xrechnung/postal_address"
require "xrechnung/party_tax_scheme"
require "xrechnung/party_legal_entity"
require "xrechnung/contact"
require "xrechnung/payment_means"
require "xrechnung/payee_financial_account"
require "xrechnung/tax_total"
require "xrechnung/tax_subtotal"
require "xrechnung/tax_category"
require "xrechnung/legal_monetary_total"
require "xrechnung/invoice_line"
require "xrechnung/item"
require "xrechnung/price"
require "xrechnung/allowance_charge"
require "xrechnung/currency"
require "xrechnung/quantity"
require "xrechnung/id"
require "builder"

module Xrechnung
  class Error < StandardError; end

  Document = Struct.new(:id, :issue_date, :due_date, :invoice_type_code, :document_currency_code, :notes, :order_reference_id,
                        :supplier, :customer, :tax_point_date, :tax_currency_code, :buyer_reference, :billing_reference, :contract_document_reference_id,
                        :project_reference_id, :tax_representative_party, :payment_means, :payment_terms_note,
                        :tax_total, :legal_monetary_total, :invoice_lines, keyword_init: true) do
    def initialize(*args)
      super

      self.invoice_type_code      = 380
      self.document_currency_code = "EUR"
      self.tax_currency_code      = "EUR"
      self.notes                  = []
      self.invoice_lines          = []
    end

    def note=(in_note)
      notes << in_note
    end

    def to_xml(indent: 2, target: "")
      xml = Builder::XmlMarkup.new(indent: indent, target: target)
      xml.instruct! :xml, version: "1.0", encoding: "UTF-8"

      xml.ubl :Invoice, \
        "xmlns:ubl"                => "urn:oasis:names:specification:ubl:schema:xsd:Invoice-2",
              "xmlns:cac"          => "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2",
              "xmlns:cbc"          => "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2",
              "xmlns:xsi"          => "http://www.w3.org/2001/XMLSchema-instance",
              "xsi:schemaLocation" => "urn:oasis:names:specification:ubl:schema:xsd:Invoice-2 http://docs.oasis-open.org/ubl/os-UBL-2.1/xsd/maindoc/UBL-Invoice-2.1.xsd" do

        xml.cbc :CustomizationID, "urn:cen.eu:en16931:2017#compliant#urn:xoev-de:kosit:standard:xrechnung_2.0"
        xml.cbc :ID, id
        xml.cbc :IssueDate, issue_date
        xml.cbc :DueDate, due_date
        xml.cbc :InvoiceTypeCode, invoice_type_code

        notes.each do |note|
          xml.cbc :Note, note
        end

        xml.cbc :TaxPointDate, tax_point_date
        xml.cbc :DocumentCurrencyCode, document_currency_code
        xml.cbc :TaxCurrencyCode, tax_currency_code
        xml.cbc :BuyerReference, buyer_reference

        xml.cac :OrderReference do
          xml.cbc :ID, order_reference_id
        end

        xml.cac :BillingReference do
          billing_reference&.to_xml(xml)
        end

        xml.cac :ContractDocumentReference do
          xml.cbc :ID, contract_document_reference_id
        end

        xml.cac :ProjectReference do
          xml.cbc :ID, project_reference_id
        end

        xml.cac :AccountingSupplierParty do
          supplier&.to_xml(xml)
        end

        xml.cac :AccountingCustomerParty do
          customer&.to_xml(xml)
        end

        xml.cac :TaxRepresentativeParty do
          tax_representative_party&.to_xml(xml)
        end

        xml.cac :PaymentMeans do
          payment_means&.to_xml(xml)
        end

        xml.cac :PaymentTerms do
          xml.cbc :Note, payment_terms_note
        end

        xml.cac :TaxTotal do
          tax_total&.to_xml(xml)
        end

        xml.cac :LegalMonetaryTotal do
          legal_monetary_total&.to_xml(xml)
        end

        invoice_lines.each do |invoice_line|
          invoice_line&.to_xml(xml)
        end
      end

      target
    end
  end

  class InvoiceDocumentReference
    attr_accessor :id, :issue_date

    def to_xml(xml)
      xml.cac :InvoiceDocumentReference do
        xml.cbc :ID, id
        xml.cbc :IssueDate, issue_date
      end
    end
  end
end
