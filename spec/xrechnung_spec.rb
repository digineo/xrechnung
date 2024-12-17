require "date"
load("spec/fixtures/ruby/party.rb")
load("spec/fixtures/ruby/payment_means.rb")
load("spec/fixtures/ruby/tax_total.rb")
load("spec/fixtures/ruby/legal_monetary_total.rb")
load("spec/fixtures/ruby/invoice_line.rb")

RSpec.describe Xrechnung do
  subject(:doc) do
    Xrechnung::Document.new
  end

  it "has a version number" do
    expect(Xrechnung::VERSION).not_to be_nil
  end

  # rubocop:disable RSpec/ExampleLength
  it "generates XML" do
    doc.id                       = "0815-99-1-a"
    doc.issue_date               = Date.parse("2020-08-21")
    doc.due_date                 = Date.parse("2020-08-31")
    doc.notes                    = ["#AAI#Rechnungsbetreff: Informationen zur Rechnung 1",
                                    "#AAI#Informationen zur Rechnung 2"]
    doc.tax_point_date           = Date.new(2021, 4, 20)
    doc.buyer_reference          = "9900 0000 - 1234 56 - 23"
    doc.purchase_order_reference = "0815-99-1"

    doc.billing_reference            = Xrechnung::InvoiceDocumentReference.new
    doc.billing_reference.id         = "Vorangegangene Rechnung 23423"
    doc.billing_reference.issue_date = Date.new(2020, 4, 23)

    doc.invoice_period            = Xrechnung::InvoicePeriod.new
    doc.invoice_period.start_date = Date.new(2021, 4, 1)
    doc.invoice_period.end_date   = Date.new(2021, 4, 30)

    doc.contract_document_reference_id = "23871349"
    doc.project_reference_id           = "Bauvorhaben Glücksstraße 4"

    doc.accounting_supplier_party = build_party

    doc.accounting_customer_party = Xrechnung::Party.new(
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

    doc.tax_representative_party = Xrechnung::Party.new(
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
        company_id:    "DE214365879"
      ),
      nested:           false,
    )

    doc.payment_means = build_payment_means

    doc.payment_terms_note = "Zahlungsziel: 10 Tage nach Zugang der Rechnung"

    doc.tax_total = build_tax_total

    doc.legal_monetary_total = build_legal_monetary_total

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
        classified_tax_category:         Xrechnung::TaxCategory.new(
          id:            "S",
          percent:       7,
          tax_scheme_id: "VAT",
        ),
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

    expected = File.read("spec/fixtures/xrechnung.xml")

    # Remove XML comments
    expected.gsub!(/\s*<!--.+?-->/mi, "")

    expect(doc.to_xml).to eq(expected)
  end
  # rubocop:enable RSpec/ExampleLength
  #

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

  it "thread safe initializer" do
    doc1 = ::Xrechnung::Document.new
    doc2 = ::Xrechnung::Document.new

    doc1.invoice_lines << Xrechnung::InvoiceLine.new

    expect(doc2.invoice_lines).to be_empty # Fails - doc1 and doc2 have the same invoice lines
  end
end
