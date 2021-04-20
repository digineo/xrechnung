require "spec_helper"
load("spec/fixtures/party_tax_scheme.rb")

RSpec.describe Xrechnung::PartyTaxScheme do
  it "generates xml" do
    expect_xml_eq_fixture(build_party_tax_scheme, "party_tax_scheme")
  end
end
