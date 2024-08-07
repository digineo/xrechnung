require "spec_helper"
load("spec/fixtures/ruby/party_legal_entity.rb")

RSpec.describe Xrechnung::PartyLegalEntity do
  it "generates xml" do
    expect_xml_eq_fixture(
      build_party_legal_entity(company_id: "DE 214365879"),
      "party_legal_entity",
    )
  end
end
