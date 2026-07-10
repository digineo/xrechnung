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

  it "uses electronic_address for EndpointID when set" do
    party.electronic_address = Xrechnung::ElectronicAddress.new(content: "4012345123456", scheme_id: "0204")
    xml                      = to_xml(party)
    expect(xml).to include %(<cbc:EndpointID schemeID="0204">4012345123456</cbc:EndpointID>)
    expect(xml).not_to include %(<cbc:EndpointID schemeID="EM">)
  end
end
