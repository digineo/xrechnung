require "spec_helper"
load("spec/fixtures/ruby/allowance_charge.rb")

RSpec.describe Xrechnung::AllowanceCharge do
  it "generates xml" do
    expect_xml_eq_fixture(build_allowance_charge, "allowance_charge")
  end
end
