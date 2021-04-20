require "spec_helper"
load("spec/fixtures/party_legal_entity.rb")

RSpec.describe Xrechnung::PartyLegalEntity do
  it "generates xml" do
    expect_xml_eq_fixture(build_party_legal_entity, "party_legal_entity")
  end
end
