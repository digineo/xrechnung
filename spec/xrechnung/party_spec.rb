require "spec_helper"
load("spec/fixtures/ruby/party.rb")

RSpec.describe Xrechnung::Party do
  let(:party) do
    build_party
  end

  it "generates xml" do
    expect_xml_eq_fixture(party, "party")
  end

  it "generates empty name tag" do
    party.name = ""

    expect(to_xml(party)).to include "<cbc:Name/>"
  end

  it "generates flat party" do
    party.nested = false

    expect(to_xml(party)).not_to include "<cbc:Party>"
  end
end
