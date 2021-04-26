require "xrechnung/version"
require "xrechnung/currency"
require "xrechnung/quantity"
require "xrechnung/id"
require "xrechnung/member_container"
require "xrechnung/contact"
require "xrechnung/party_legal_entity"
require "xrechnung/party_tax_scheme"
require "xrechnung/postal_address"
require "xrechnung/party"
require "xrechnung/payee_financial_account"
require "xrechnung/payment_means"
require "xrechnung/tax_total"
require "xrechnung/tax_category"
require "xrechnung/tax_subtotal"
require "xrechnung/legal_monetary_total"
require "xrechnung/item"
require "xrechnung/allowance_charge"
require "xrechnung/price"
require "xrechnung/invoice_line"
require "xrechnung/invoice_document_reference"
require "builder"
require "date"

module Xrechnung
  class Error < StandardError; end

  class Document
    include MemberContainer

    # Rechnungsnummer
    #
    # @!attribute id
    #   @return [String]
    member :id, type: String

    # @!attribute issue_date
    # @return [Date]
    member :issue_date, type: Date

    # @!attribute due_date
    # @return [Date]
    member :due_date, type: Date

    # @!attribute invoice_type_code
    # @return [Integer]
    member :invoice_type_code, type: Integer, default: 380

    # @!attribute document_currency_code
    # @return [String]
    member :document_currency_code, type: String, default: "EUR"

    # @!attribute notes
    # @return [Array]
    member :notes, type: Array, default: []

    # @!attribute order_reference_id
    # @return [String]
    member :order_reference_id, type: String

    # @!attribute accounting_supplier_party
    # @return [Xrechnung::Party]
    member :accounting_supplier_party, type: Xrechnung::Party

    # @!attribute customer
    # @return [Xrechnung::Party]
    member :customer, type: Xrechnung::Party

    # @!attribute tax_point_date
    # @return [Date]
    member :tax_point_date, type: Date

    # @!attribute tax_currency_code
    # @return [String]
    member :tax_currency_code, type: String, default: "EUR"

    # @!attribute buyer_reference
    # @return [String]
    member :buyer_reference, type: String

    # @!attribute billing_reference
    # @return [Xrechnung::InvoiceDocumentReference]
    member :billing_reference, type: Xrechnung::InvoiceDocumentReference, optional: true

    # @!attribute contract_document_reference_id
    # @return [Integer]
    member :contract_document_reference_id, type: Integer

    # @!attribute project_reference_id
    # @return [String]
    member :project_reference_id, type: String

    # @!attribute tax_representative_party
    # @return [Xrechnung::Party]
    member :tax_representative_party, type: Xrechnung::Party, optional: true

    # @!attribute payment_means
    # @return [Xrechnung::PaymentMeans]
    member :payment_means, type: Xrechnung::PaymentMeans

    # @!attribute payment_terms_note
    # @return [String]
    member :payment_terms_note, type: String

    # @!attribute tax_total
    # @return [Xrechnung::TaxTotal]
    member :tax_total, type: Xrechnung::TaxTotal

    # @!attribute legal_monetary_total
    # @return [Xrechnung::LegalMonetaryTotal]
    member :legal_monetary_total, type: Xrechnung::LegalMonetaryTotal

    # @!attribute invoice_lines
    # @return [Array]
    member :invoice_lines, type: Array, default: []

    def to_xml(indent: 2, target: "")
      xml = Builder::XmlMarkup.new(indent: indent, target: target)
      xml.instruct! :xml, version: "1.0", encoding: "UTF-8"

      xml.ubl :Invoice, \
        "xmlns:ubl"          => "urn:oasis:names:specification:ubl:schema:xsd:Invoice-2",
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

        unless members[:billing_reference][:optional] && billing_reference.nil?
          xml.cac :BillingReference do
            billing_reference&.to_xml(xml)
          end
        end

        xml.cac :ContractDocumentReference do
          xml.cbc :ID, contract_document_reference_id
        end

        xml.cac :ProjectReference do
          xml.cbc :ID, project_reference_id
        end

        xml.cac :AccountingSupplierParty do
          accounting_supplier_party&.to_xml(xml)
        end

        xml.cac :AccountingCustomerParty do
          customer&.to_xml(xml)
        end

        unless members[:tax_representative_party][:optional] && tax_representative_party.nil?
          xml.cac :TaxRepresentativeParty do
            tax_representative_party&.to_xml(xml)
          end
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
end
