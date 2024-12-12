require "spec_helper"
load("spec/fixtures/ruby/payment_mandate.rb")

RSpec.describe Xrechnung::PaymentMandate do
  it "generates xml" do
    expect_xml_eq_fixture(build_payment_mandate, "payment_mandate")
  end
end
