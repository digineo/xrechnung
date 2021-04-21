require "spec_helper"
load("spec/fixtures/ruby/invoice_line.rb")

RSpec.describe Xrechnung::InvoiceLine do
  it "generates xml" do
    expect_xml_eq_fixture(build_invoice_line, "invoice_line")
  end
end
