require "xrechnung/version"
require "date"
require "xrechnung/currency"
require "xrechnung/quantity"
require "xrechnung/id"
require "xrechnung/member_container"
require "xrechnung/delivery"
require "xrechnung/additional_document_reference"
require "xrechnung/contact"
require "xrechnung/party_identification"
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

module Xrechnung
  class Error < StandardError; end

  class Document
    include MemberContainer

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

    # Der Begin der Leistungsperiode
    #
    # @!attribute invoice_start_date
    #   @return [Date]
    member :invoice_start_date, type: Date

    # Das Ende der Leistungsperiode
    #
    # @!attribute invoice_end_date
    #   @return [Date]
    member :invoice_end_date, type: Date

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
    member :purchase_order_reference, type: String

    # Sales order reference BT-14
    #
    # Eine vom Verkäufer ausgegebene Kennung für einen referenzierten Auftrag.
    #
    # @!attribute sales_order_reference
    #   @return [String]
    member :sales_order_reference, type: String, optional: true

    # Invoiced object identifier BT-18
    #
    # Eine vom Verkäufer angegebene Kennung für ein Objekt, auf das sich die Rechnung bezieht.
    #
    # @!attribute invoiced_object_identifier
    #   @return [String]
    member :invoiced_object_identifier, type: String, optional: true

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
    member :tax_currency_code, type: String, default: "EUR"

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

    # Contract reference BT-12
    #
    # Eine eindeutige Bezeichnung des Vertrages (z. B. Vertragsnummer).
    #
    # @!attribute contract_document_reference_id
    #   @return [String]
    member :contract_document_reference_id, type: String

    # Project reference BT-11
    #
    # Die Kennung eines Projektes, auf das sich die Rechnung bezieht.
    #
    # @!attribute project_reference_id
    #   @return [String]
    member :project_reference_id, type: String

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

    # Ein Element um Rechnungs PDFs inline mit base64 encoded zu embedden.
    #  @return [Xrechnung::AdditionalDocumentReference]
    member :additional_document_reference, type: Xrechnung::AdditionalDocumentReference

    # INVOICE LINE BG-25
    #
    # Eine Gruppe von Informationselementen, die Informationen über einzelne
    # Rechnungspositionen liefern.
    #
    # @!attribute invoice_lines
    #   @return [Array]
    member :invoice_lines, type: Array, default: []

    # Ein Element um Rechnungs PDFs inline mit base64 encoded zu embedden.
    #  @return [Xrechnung::Delivery]
    member :delivery, type: Xrechnung::Delivery

#############################################################################################
# IMPORTANT!
# !!! The order of the xml.cbc's is absolutly important for the xsl schema validator !!!
# so don't just add new elements at the end, the final element needs to be the invoice lines
############################################################################################# 

    def to_xml(indent: 2, target: "")
      xml = Builder::XmlMarkup.new(indent: indent, target: target)
      xml.instruct! :xml, version: "1.0", encoding: "UTF-8"

      xml.ubl :Invoice, \
        "xmlns:ubl"          => "urn:oasis:names:specification:ubl:schema:xsd:Invoice-2",
        "xmlns:cac"          => "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2",
        "xmlns:cbc"          => "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2",
        "xmlns:xsi"          => "http://www.w3.org/2001/XMLSchema-instance",
        "xsi:schemaLocation" => "urn:oasis:names:specification:ubl:schema:xsd:Invoice-2 http://docs.oasis-open.org/ubl/os-UBL-2.1/xsd/maindoc/UBL-Invoice-2.1.xsd" do
        xml.cbc :CustomizationID, "urn:cen.eu:en16931:2017#compliant#urn:xoev-de:kosit:standard:xrechnung_2.2"
        xml.cbc :ID, id
        xml.cbc :IssueDate, issue_date
        xml.cbc :DueDate, due_date
        xml.cbc :InvoiceTypeCode, invoice_type_code

        notes.each do |note|
          xml.cbc :Note, note
        end

        xml.cbc :TaxPointDate, tax_point_date if tax_point_date
        xml.cbc :DocumentCurrencyCode, document_currency_code
        xml.cbc :TaxCurrencyCode, tax_currency_code if tax_currency_code
        xml.cbc :BuyerReference, buyer_reference

        unless invoice_start_date.nil? && invoice_end_date.nil?
          xml.cac :InvoicePeriod do
            xml.cbc:StartDate, invoice_start_date
            xml.cbc:EndDate, invoice_end_date
          end
        end

        xml.cac :OrderReference do
          xml.cbc :ID, purchase_order_reference
          unless members[:sales_order_reference][:optional] && sales_order_reference.nil?
            xml.cbc :SalesOrderID, sales_order_reference
          end
        end

        unless contract_document_reference_id.nil?
          xml.cac :ContractDocumentReference do
            xml.cbc :ID, contract_document_reference_id
          end
        end

        unless invoiced_object_identifier.nil?
          xml.cac :AdditionalDocumentReference do
            xml.cbc :ID, invoiced_object_identifier
          end
        end

        additional_document_reference&.to_xml(xml)

        unless project_reference_id.nil?
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

        unless delivery.nil?
          delivery&.to_xml(xml)
        end

        unless payment_means.nil?
          xml.cac :PaymentMeans do
            payment_means&.to_xml(xml)
          end
        end

        unless payment_terms_note.nil?
          xml.cac :PaymentTerms do
            xml.cbc :Note, payment_terms_note
          end
        end

        unless tax_total.nil?
          xml.cac :TaxTotal do
            tax_total&.to_xml(xml)
          end
        end

        unless legal_monetary_total.nil?
          xml.cac :LegalMonetaryTotal do
            legal_monetary_total&.to_xml(xml)
          end
        end

        invoice_lines.each do |invoice_line|
          invoice_line&.to_xml(xml)
        end

        # !!!
        # don't add any other elements after invoice_lines, it looks like the validator doesn't like that
        # !!!

        #unless members[:billing_reference][:optional] && billing_reference.nil?
          #xml.cac :BillingReference do
            #billing_reference&.to_xml(xml)
          #end
        #end


        #unless members[:tax_representative_party][:optional] && tax_representative_party.nil?
          #xml.cac :TaxRepresentativeParty do
            #tax_representative_party&.to_xml(xml)
          #end
        #end

      end
      target
    end
  end
end
