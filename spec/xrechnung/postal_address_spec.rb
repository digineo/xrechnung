require "spec_helper"
load("spec/fixtures/postal_address.rb")

RSpec.describe Xrechnung::PostalAddress do
  it "generates xml" do
    expect_xml_eq_fixture(build_postal_address, "postal_address")
  end
end
