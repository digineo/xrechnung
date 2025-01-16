require "spec_helper"
load("spec/fixtures/ruby/payment_means.rb")

RSpec.describe Xrechnung::PaymentMeans do
  it "generates xml" do
    expect_xml_eq_fixture(build_payment_means, "payment_means")
  end

  context "without optional fields" do
    subject(:doc) { payment_means.to_xml(xml) }

    let(:payment_means) do
      Xrechnung::PaymentMeans.new(
        payment_means_code:      30,
        payee_financial_account: build_payee_financial_account,
      )
    end
    let(:xml) { Builder::XmlMarkup.new(indent: 2) }

    it "generates xml without InstructionNote" do
      expect(doc).not_to include("InstructionNote")
    end

    it "generates xml without PaymentID" do
      expect(doc).not_to include("PaymentID")
    end
  end
end
