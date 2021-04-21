require "spec_helper"
load("spec/fixtures/ruby/legal_monetary_total.rb")

RSpec.describe Xrechnung::LegalMonetaryTotal do
  it "generates xml" do
    expect_xml_eq_fixture(build_legal_monetary_total, "legal_monetary_total")
  end
end
