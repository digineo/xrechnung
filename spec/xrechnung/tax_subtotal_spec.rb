require "spec_helper"
load("spec/fixtures/ruby/tax_subtotal.rb")

RSpec.describe Xrechnung::TaxSubtotal do
  it "generates xml" do
    expect_xml_eq_fixture(build_tax_subtotal, "tax_subtotal")
  end
end
