require 'spec_helper'
load("spec/fixtures/party.rb")


RSpec.describe Xrechnung::Party do
  it "generates xml" do
    expect_xml_eq_fixture(build_party, "party")
  end
end
