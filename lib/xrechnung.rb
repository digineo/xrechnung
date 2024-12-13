require "xrechnung/version"
require "date"
require "xrechnung/currency"
require "xrechnung/quantity"
require "xrechnung/id"
require "xrechnung/member_container"
require "xrechnung/contact"
require "xrechnung/party_identification"
require "xrechnung/party_legal_entity"
require "xrechnung/party_tax_scheme"
require "xrechnung/postal_address"
require "xrechnung/party"
require "xrechnung/payee_financial_account"
require "xrechnung/payment_mandate"
require "xrechnung/payee_party"
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
require "xrechnung/invoice_period"
require "builder"

module Xrechnung
  class Error < StandardError; end

  class Document
    include MemberContainer

    # Default customization specs
    DEFAULT_CUSTOMIZATION_ID = "urn:cen.eu:en16931:2017#compliant#urn:xeinkauf.de:kosit:xrechnung_3.0"
    DEFAULT_PROFILE_ID = "urn:fdc:peppol.eu:2017:poacc:billing:01:1.0"

    # Document customization identifier
    #
    # @!attribute customization_id
    #   @return [String]
    member :customization_id, type: String, default: DEFAULT_CUSTOMIZATION_ID

    # Document profile identifier
    #
    # @!attribute profile_id
    #   @return [String]
    member :profile_id, type: String, default: DEFAULT_PROFILE_ID

    # Invoice number BT-1
    #
    # Eine eindeutige Kennung der Rechnung, die diese im System des Verkäufers identifiziert.
    # Anmerkung: Es ist kein „identification scheme“ zu verwenden.
    #
    # @!attribute id
    #   @return [String]
    member :id, type: String

    # Invoice issue date BT-2
    #
    # Das Datum, an dem die Rechnung ausgestellt wurde.
    #
    # @!attribute issue_date
    #   @return [Date]
    member :issue_date, type: Date

    # Payment due date BT-9
    #
    # Das Fälligkeitsdatum des Rechnungsbetrages.
    #
    # @!attribute due_date
    #   @return [Date]
    member :due_date, type: Date

    # Invoice type code BT-3
    # Ein Code, der den Funktionstyp der Rechnung angibt.
    #
    # Anmerkung: Der Rechnungstyp muss gemäß UNTDID 1001 spezifiziert werden.
    # Folgende Codes aus der Codeliste sollen verwendet werden:
    # • 326 (Partial invoice)
    # • 380 (Commercial invoice)
    # • 384 (Corrected invoice)
    # • 389 (Self-billed invoice)
    # • 381 (Credit note)
    # • 875 (Partial construction invoice)
    # • 876 (Partial final construction invoice)
    # • 877 (Final construction invoice)
    #
    # @!attribute invoice_type_code
    #   @return [Integer]
    member :invoice_type_code, type: Integer, default: 380

    # Invoice currency code BT-5
    #
    # Die Währung, in der alle Rechnungsbeträge angegeben werden, ausgenommen ist der Umsatzsteuer-
    # Gesamtbetrag, der in der Abrechnungswährung anzugeben ist.
    # Anmerkung: Nur eine Währung ist in der Rechnung zu verwenden, der „Invoice total VAT amount in accounting
    # currency“ (BT-111) ist in der Abrechnungswährung auszuweisen. Die gültigen Währungen sind bei der ISO 4217
    # „Codes for the representation of currencies and funds“ registriert. Nur die Alpha-3-Darstellung darf verwendet
    # werden.
    #
    # @!attribute document_currency_code
    #   @return [String]
    member :document_currency_code, type: String, default: "EUR"

    # INVOICE NOTE BG-1
    #
    # Eine Gruppe von Informationselementen für rechnungsrelevante Erläuterungen
    # mit Hinweisen auf den Rechnungsbetreff.
    #
    # @!attribute notes
    #   @return [Array]
    member :notes, type: Array, default: []

    # Purchase order reference BT-13
    #
    # Eine vom Erwerber ausgegebene Kennung für eine referenzierte Bestellung.
    #
    # @!attribute purchase_order_reference
    #   @return [String]
    member :purchase_order_reference, type: String, optional: true

    # Sales order reference BT-14
    #
    # Eine vom Verkäufer ausgegebene Kennung für einen referenzierten Auftrag.
    #
    # @!attribute sales_order_reference
    #   @return [String]
    member :sales_order_reference, type: String, optional: true

    # Gruppe SELLER BG-4
    #
    # Eine Gruppe von Informationselementen, die Informationen über den Verkäufer liefern.
    #
    # @!attribute accounting_supplier_party
    #   @return [Xrechnung::Party]
    member :accounting_supplier_party, type: Xrechnung::Party

    # BUYER BG-7
    #
    # Eine Gruppe von Informationselementen, die Informationen über den Erwerber liefern.
    #
    # @!attribute accounting_customer_party
    #   @return [Xrechnung::Party]
    member :accounting_customer_party, type: Xrechnung::Party

    # Value added tax point date BT-7
    #
    # Das Datum, zu dem die Umsatzsteuer für den Verkäufer und für den Erwerber abrechnungsrelevant wird.
    # Die Anwendung von BT-7 und 8 schließen sich gegenseitig aus.
    #
    # @!attribute tax_point_date
    #   @return [Date]
    member :tax_point_date, type: Date

    # VAT accounting currency code BT-6
    #
    # Die für die Umsatzsteuer-Abrechnungs- und -Meldezwecke verwendete Währung, die im Land des Verkäufers gültig
    # ist oder verlangt wird.
    # Anmerkung: Zu Verwenden in Kombination mit „Invoice total VAT amount in accounting currency“ (BT-111), wenn
    # die Umsatzsteuerabrechnungswährung von der Rechnungswährung abweicht. Die gültigen Währungen sind bei
    # der ISO 4217 „Codes for the representation of currencies and funds“ registriert. Nur die Alpha-3-Darstellung darf
    # verwendet werden.
    #
    # @!attribute tax_currency_code
    #   @return [String]
    member :tax_currency_code, type: String

    # Buyer reference BT-10
    #
    # Ein vom Erwerber zugewiesener und für interne Lenkungszwecke benutzter Bezeichner.
    # Anmerkung: Im Rahmen des Steuerungsprojekts eRechnung ist mit der so genannten Leitweg-ID eine
    # Zuordnungsmöglichkeit entwickelt worden, deren verbindliche Nutzung von Bund und mehreren Ländern
    # vorgegeben wird. Die Leitweg-ID ist prinzipiell für Bund, Länder und Kommunen einsetzbar. Für die Darstellung der
    # Leitweg-ID wird das in XRechnung verpflichtende Feld Buyer Reference benutzt.
    # Länder und Kommunen, die ihren Rechnungsstellern abweichend von der Leitweg-ID eigene Zuordnungsmuster
    # mitteilen, können diese statt der Leitweg-ID im Feld Buyer Reference verwenden.
    # Hinweis: Es existiert eine Handreichung zur Bildung der Leitweg-ID, die über die KoSIT zu erhalten ist (siehe Website
    # XRechnung bzw. FAQ-Liste).
    #
    # @!attribute buyer_reference
    #   @return [String]
    member :buyer_reference, type: String

    # @!attribute billing_reference
    #   @return [Xrechnung::InvoiceDocumentReference]
    member :billing_reference, type: Xrechnung::InvoiceDocumentReference, optional: true

    # @!attribute invoice_period
    #   @return [Xrechnung::InvoicePeriod]
    member :invoice_period, type: Xrechnung::InvoicePeriod, optional: true

    # Contract reference BT-12
    #
    # Eine eindeutige Bezeichnung des Vertrages (z. B. Vertragsnummer).
    #
    # @!attribute contract_document_reference_id
    #   @return [String]
    member :contract_document_reference_id, type: String, optional: true

    # Project reference BT-11
    #
    # Die Kennung eines Projektes, auf das sich die Rechnung bezieht.
    #
    # @!attribute project_reference_id
    #   @return [String]
    member :project_reference_id, type: String, optional: true

    # SELLER TAX REPRESENTATIVE PARTY BG-11
    #
    # Eine Gruppe von Informationselementen, die Informationen über den
    # Steuervertreter des Verkäufers liefern.
    #
    # @!attribute tax_representative_party
    #   @return [Xrechnung::Party]
    member :tax_representative_party, type: Xrechnung::Party, optional: true

    # PAYMENT INSTRUCTIONS BG-16
    #
    # Eine Gruppe von Informationselementen, die Informationen darüber liefern, wie die Zahlung
    # erfolgen soll.
    #
    # @!attribute payment_means
    #   @return [Xrechnung::PaymentMeans]
    member :payment_means, type: Xrechnung::PaymentMeans

    # PAYEE PARTY BG-10
    #
    # A group of business terms providing information about the Payee, i.e. the role that receives
    # the payment. Shall be used when the Payee is different from the Seller.
    #
    # @!attribute payee_party
    #   @return [Xrechnung::PayeeParty]
    member :payee_party, type: Xrechnung::PayeeParty, optional: true

    # Payment terms BT-20
    #
    # Eine Textbeschreibung der Zahlungsbedingungen, die für den fälligen Zahlungsbetrag gelten (einschließlich
    # Beschreibung möglicher Skonto- und Verzugsbedingungen). Dieses Informationselement kann mehrere Zeilen und
    # mehrere Angaben zu Zahlungsbedingungen beinhalten und sowohl unstrukturierten als strukturierten Text enthalten.
    # Der unstrukturierte Text darf dabei keine # enthalten.
    #
    # @!attribute payment_terms_note
    #   @return [String]
    member :payment_terms_note, type: String

    # VAT BREAKDOWN BG-23
    #
    # Eine Gruppe von Informationselementen, die Informationen über die
    # Umsatzsteueraufschlüsselung in verschiedene Kategorien liefern.
    #
    # @!attribute tax_total
    #   @return [Xrechnung::TaxTotal]
    member :tax_total, type: Xrechnung::TaxTotal

    # DOCUMENT TOTALS BG-22
    #
    # Eine Gruppe von Informationselementen, die die monetären Gesamtbeträge der Rechnung
    # liefern.
    #
    # @!attribute legal_monetary_total
    #   @return [Xrechnung::LegalMonetaryTotal]
    member :legal_monetary_total, type: Xrechnung::LegalMonetaryTotal

    # INVOICE LINE BG-25
    #
    # Eine Gruppe von Informationselementen, die Informationen über einzelne
    # Rechnungspositionen liefern.
    #
    # @!attribute invoice_lines
    #   @return [Array]
    member :invoice_lines, type: Array, default: []

    # DOCUMENT LEVEL ALLOWANCES AND CHARGES BG-20, BG-21
    #
    # A group of business terms providing information about allowances
    # applicable to the Invoice as a whole. A group of business terms providing
    # information about charges and taxes other than VAT, applicable to the
    # Invoice as a whole.
    #
    # @!attribute allowance_charges
    #   @return [Array]
    member :allowance_charges, type: Array, default: []

    def to_xml(indent: 2, target: "")
      xml = Builder::XmlMarkup.new(indent: indent, target: target)
      xml.instruct! :xml, version: "1.0", encoding: "UTF-8"

      xml.ubl :Invoice, \
        "xmlns:ubl"          => "urn:oasis:names:specification:ubl:schema:xsd:Invoice-2",
        "xmlns:cac"          => "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2",
        "xmlns:cbc"          => "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2",
        "xmlns:xsi"          => "http://www.w3.org/2001/XMLSchema-instance",
        "xsi:schemaLocation" => "urn:oasis:names:specification:ubl:schema:xsd:Invoice-2 http://docs.oasis-open.org/ubl/os-UBL-2.1/xsd/maindoc/UBL-Invoice-2.1.xsd" do
        xml.cbc :CustomizationID, customization_id
        xml.cbc :ProfileID, profile_id
        xml.cbc :ID, id
        xml.cbc :IssueDate, issue_date
        xml.cbc :DueDate, due_date
        xml.cbc :InvoiceTypeCode, invoice_type_code

        notes.each do |note|
          xml.cbc :Note, note
        end

        xml.cbc :TaxPointDate, tax_point_date unless tax_point_date.nil?
        xml.cbc :DocumentCurrencyCode, document_currency_code
        xml.cbc :TaxCurrencyCode, tax_currency_code unless tax_currency_code.nil?
        xml.cbc :BuyerReference, buyer_reference

        invoice_period&.to_xml(xml) unless self.class.members[:invoice_period].optional && invoice_period.nil?

        unless self.class.members[:purchase_order_reference].optional && purchase_order_reference.nil? &&
               self.class.members[:sales_order_reference].optional && sales_order_reference.nil?
          xml.cac :OrderReference do
            unless self.class.members[:purchase_order_reference].optional && purchase_order_reference.nil?
              xml.cbc :ID, purchase_order_reference
            end
            unless self.class.members[:sales_order_reference].optional && sales_order_reference.nil?
              xml.cbc :SalesOrderID, sales_order_reference
            end
          end
        end

        unless self.class.members[:billing_reference].optional && billing_reference.nil?
          xml.cac :BillingReference do
            billing_reference&.to_xml(xml)
          end
        end

        unless self.class.members[:contract_document_reference_id].optional && contract_document_reference_id.nil?
          xml.cac :ContractDocumentReference do
            xml.cbc :ID, contract_document_reference_id
          end
        end

        unless self.class.members[:project_reference_id].optional && project_reference_id.nil?
          xml.cac :ProjectReference do
            xml.cbc :ID, project_reference_id
          end
        end

        xml.cac :AccountingSupplierParty do
          accounting_supplier_party&.to_xml(xml)
        end

        xml.cac :AccountingCustomerParty do
          accounting_customer_party&.to_xml(xml)
        end

        unless self.class.members[:tax_representative_party].optional && tax_representative_party.nil?
          xml.cac :TaxRepresentativeParty do
            tax_representative_party&.to_xml(xml)
          end
        end

        xml.cac :PaymentMeans do
          payment_means&.to_xml(xml)
        end

        unless self.class.members[:payee_party].optional && payee_party.nil?
          payee_party&.to_xml(xml)
        end

        xml.cac :PaymentTerms do
          xml.cbc :Note, payment_terms_note
        end

        allowance_charges.each do |allowance_charge|
          allowance_charge&.to_xml(xml)
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
