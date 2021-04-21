require "spec_helper"
load("spec/fixtures/ruby/tax_total.rb")

RSpec.describe Xrechnung::TaxTotal do
  it "generates xml" do
    expect_xml_eq_fixture(build_tax_total, "tax_total")
  end
end
