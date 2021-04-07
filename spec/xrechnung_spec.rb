require "date"

RSpec.describe Xrechnung do
  it "has a version number" do
    expect(Xrechnung::VERSION).not_to be nil
  end

  it "generates XML" do
    doc = Xrechnung::Document.new
    doc.id         = "ERB_UBL_INVOICE_001"
    doc.issue_date = Date.parse("2020-11-13")
    doc.due_date   = Date.parse("2020-12-01")
    doc.note       = "Das ist ein globaler Kommentar zur Rechnung.\nAuch Zeilenumbrüche in einer Note werden berücksichtigt."

    doc.order_reference_id = 1234567890

    doc.customer   = Xrechnung::Party.new
    doc.customer.name = "BRZ GmbH"

    doc.supplier   = Xrechnung::Party.new
    doc.supplier.name = "Mustermann GmbH"


    expected = File.read("spec/fixtures/xrechnung.xml")

    # Remove XML comments
    expected.gsub!(/\s*<!--.+?-->/mi, "")

    expect(doc.to_xml).to eq(expected)
  end
end
