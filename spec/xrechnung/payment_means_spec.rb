require "spec_helper"
load("spec/fixtures/ruby/payment_means.rb")

RSpec.describe Xrechnung::PaymentMeans do
  it "generates xml" do
    expect_xml_eq_fixture(build_payment_means, "payment_means")
  end
end
