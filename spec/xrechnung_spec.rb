require "date"
load("spec/fixtures/ruby/party.rb")

RSpec.describe Xrechnung do
  it "has a version number" do
    expect(Xrechnung::VERSION).not_to be nil
  end

  # rubocop:disable RSpec/ExampleLength
  it "generates XML" do
    doc                    = Xrechnung::Document.new
    doc.id                 = "0815-99-1-a"
    doc.issue_date         = Date.parse("2020-08-21")
    doc.due_date           = Date.parse("2020-08-31")
    doc.note               = "#AAI#Rechnungsbetreff: Informationen zur Rechnung 1"
    doc.note               = "#AAI#Informationen zur Rechnung 2"
    doc.tax_point_date     = Date.new(2021, 4, 20)
    doc.buyer_reference    = "9900 0000 - 1234 56 - 23"
    doc.order_reference_id = "0815-99-1"

    doc.billing_reference            = Xrechnung::InvoiceDocumentReference.new
    doc.billing_reference.id         = "Vorangegangene Rechnung 23423"
    doc.billing_reference.issue_date = Date.new(2020, 4, 23)

    doc.contract_document_reference_id = 23_871_349
    doc.project_reference_id           = "Bauvorhaben Glücksstraße 4"

    doc.supplier = build_party

    party                                 = Xrechnung::Party.new
    postal_address                        = Xrechnung::PostalAddress.new
    postal_address.street_name            = "Malerweg 2"
    postal_address.additional_street_name = "Hinterhof A"
    postal_address.city_name              = "Großstadt"
    postal_address.postal_zone            = "01091"
    postal_address.country_subentity      = "Sachsen"
    postal_address.country_id             = "DE"
    party.postal_address                  = postal_address
    party_legal_entity                    = Xrechnung::PartyLegalEntity.new
    party_legal_entity.registration_name  = "Bauamt GmbH & Co KG"
    party.party_legal_entity              = party_legal_entity
    contact                               = Xrechnung::Contact.new
    contact.name                          = "Manfred Mustermann"
    contact.telephone                     = "+49 12345 98 765 - 44"
    contact.electronic_mail               = "manfred.mustermann@bauamt.de"
    build_contact_value                   = contact
    party.contact                         = build_contact_value
    doc.customer                          = party

    expected = File.read("spec/fixtures/xrechnung.xml")

    # Remove XML comments
    expected.gsub!(/\s*<!--.+?-->/mi, "")

    expect(doc.to_xml).to eq(expected)
  end
end
