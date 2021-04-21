require "spec_helper"
load("spec/fixtures/ruby/postal_address.rb")

RSpec.describe Xrechnung::PostalAddress do
  it "generates xml" do
    expect_xml_eq_fixture(build_postal_address, "postal_address")
  end

  context "empty postal_address" do
    let(:postal_address) { Xrechnung::PostalAddress.new }

    it "generates empty xml" do
      expect_xml_eq_fixture(postal_address, "postal_address_empty")
    end
  end
end
