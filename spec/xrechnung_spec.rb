require "date"
load("spec/fixtures/ruby/party.rb")
load("spec/fixtures/ruby/payment_means.rb")
load("spec/fixtures/ruby/tax_total.rb")
load("spec/fixtures/ruby/legal_monetary_total.rb")
load("spec/fixtures/ruby/invoice_line.rb")

RSpec.describe Xrechnung do
  it "has a version number" do
    expect(Xrechnung::VERSION).not_to be_nil
  end

  it "thread safe initializer" do
    doc1 = Xrechnung::Document.new
    doc2 = Xrechnung::Document.new

    doc1.invoice_lines << Xrechnung::InvoiceLine.new

    expect(doc2.invoice_lines).to be_empty # Fails - doc1 and doc2 have the same invoice lines
  end

  it "initializing with hash" do
    doc = Xrechnung::Document.new(
      id: "0815-99-1-a",
    )

    expect(doc.id).to eq("0815-99-1-a")
  end

  context "an invoice" do
    subject(:doc) do
      Xrechnung::Document.new
    end

    let(:accounting_customer_party) {
      Xrechnung::Party.new(
        postal_address:       Xrechnung::PostalAddress.new(
          street_name:            "Malerweg 2",
          additional_street_name: "Hinterhof A",
          city_name:              "Großstadt",
          postal_zone:            "01091",
          country_subentity:      "Sachsen",
          country_id:             "DE",
        ),
        party_identification: Xrechnung::PartyIdentification.new(
          id: "70012",
        ),
        party_legal_entity:   Xrechnung::PartyLegalEntity.new(
          registration_name: "Bauamt GmbH & Co KG",
        ),
        contact:              Xrechnung::Contact.new(
          name:            "Manfred Mustermann",
          telephone:       "+49 12345 98 765 - 44",
          electronic_mail: "manfred.mustermann@bauamt.de",
        ),
      )
    }

    let(:tax_representative_party) {
      Xrechnung::Party.new(
        name:             "Donald Duck",
        postal_address:   Xrechnung::PostalAddress.new(
          street_name:            "Malerweg 2",
          additional_street_name: "Hinterhof A",
          city_name:              "Großstadt",
          postal_zone:            "01091",
          country_subentity:      "Sachsen",
          country_id:             "DE",
        ),
        party_tax_scheme: Xrechnung::PartyTaxScheme.new(
          tax_scheme_id: "VAT",
          company_id:    "DE214365879",
        ),
        nested:           false,
      )
    }

    let(:tax_category_7) {
      Xrechnung::TaxCategory.new(
        id:            "S",
        percent:       7,
        tax_scheme_id: "VAT",
      )
    }

    let(:tax_category_19) {
      Xrechnung::TaxCategory.new(
        id:            "S",
        percent:       19,
        tax_scheme_id: "VAT",
      )
    }

    def read_fixture(name)
      File.read("spec/fixtures/#{name}.xml")
        .gsub!(/\s*<!--.+?-->/mi, "") # Remove XML comments
    end

    context "generating xml" do
      before do
        doc.id                       = "0815-99-1-a"
        doc.issue_date               = Date.parse("2020-08-21")
        doc.due_date                 = Date.parse("2020-08-31")
        doc.notes                    = ["#AAI#Rechnungsbetreff: Informationen zur Rechnung 1",
                                        "#AAI#Informationen zur Rechnung 2"]
        doc.tax_point_date           = Date.new(2021, 4, 20)
        doc.buyer_reference          = "9900 0000 - 1234 56 - 23"
        doc.purchase_order_reference = "0815-99-1"
        doc.sales_order_reference    = "XXYYZZ-123"

        doc.invoice_period            = Xrechnung::InvoicePeriod.new
        doc.invoice_period.start_date = Date.new(2021, 4, 1)
        doc.invoice_period.end_date   = Date.new(2021, 4, 30)

        doc.accounting_supplier_party = build_party
        doc.accounting_customer_party = accounting_customer_party
        doc.tax_representative_party  = tax_representative_party
        doc.payment_terms_note        = "Zahlungsziel: 10 Tage nach Zugang der Rechnung"
        doc.payment_means             = build_payment_means
      end

      it "commercial invoice" do
        doc.contract_document_reference_id = "23871349"
        doc.project_reference_id           = "Bauvorhaben Glücksstraße 4"
        doc.prepaid_amount                 = 100
        doc.allowance_charges << Xrechnung::AllowanceCharge.new(
          charge_indicator:             true,
          tax_category:                 tax_category_7,
          amount:                       20,
          allowance_charge_reason:      "Minimum order not fulfilled",
          allowance_charge_reason_code: "DAN",
        )

        doc.invoice_lines << build_invoice_line_with_allowance_charge
        doc.invoice_lines << Xrechnung::InvoiceLine.new(
          id:                    1,
          invoice_period:        Xrechnung::InvoicePeriod.new(start_date: Date.new(2021, 4, 7), end_date: Date.new(2021, 4, 13)),
          invoiced_quantity:     Xrechnung::Quantity.new(5, "XPP"),
          line_extension_amount: 1285.70,
          item:                  Xrechnung::Item.new(
            description:                     "Dichtungsfolie 2.5 mm stark, 1.5 m breit",
            name:                            "Dichtungsfolie",
            standard_item_identification_id: Xrechnung::Id.new("D4567890", "0160"),
            commodity_classification:        nil,
            classified_tax_category:         tax_category_7,
          ),
          price:                 Xrechnung::Price.new(
            price_amount:     257.14,
            base_quantity:    Xrechnung::Quantity.new(1, "XPP"),
            allowance_charge: Xrechnung::AllowanceCharge.new(
              charge_indicator: false,
              amount:           0,
              base_amount:      257.14,
            ),
          ),
        )

        expect(doc.to_xml).to match_fixture("commercial_invoice")
      end

      it "corrected invoice" do
        doc.invoice_type_code = 384
        doc.invoice_lines << build_invoice_line_with_allowance_charge
        doc.billing_reference = Xrechnung::InvoiceDocumentReference.new(
          id:         "Vorangegangene Rechnung 23423",
          issue_date: Date.new(2020, 4, 23),
        )

        expect(doc.to_xml).to match_fixture("corrected_invoice")
      end
    end

    it "omits tag if attribute is set to optional" do
      expect(doc.to_xml).not_to include "<cac:BillingReference"
    end

    it "omits tax_representative_party" do
      doc.tax_representative_party = nil

      expect(doc.to_xml).not_to include "<cac:TaxRepresentativeParty"
    end

    it "sets defaults" do
      expect(doc.to_xml).to include "<cbc:InvoiceTypeCode>380</cbc:InvoiceTypeCode>"
    end
  end
end
