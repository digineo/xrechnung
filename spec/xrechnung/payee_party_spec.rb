require "spec_helper"
load("spec/fixtures/ruby/payee_party.rb")

RSpec.describe Xrechnung::PayeeParty do
  it "generates xml" do
    expect_xml_eq_fixture(build_payee_party, "payee_party")
  end
end
