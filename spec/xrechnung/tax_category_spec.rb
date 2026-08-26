require "spec_helper"
load("spec/fixtures/ruby/tax_category.rb")

RSpec.describe Xrechnung::TaxCategory do
  it "generates xml" do
    expect_xml_eq_fixture(build_tax_category(exempt: true), "tax_category")
  end

  context "comparing" do
    it { expect(build_tax_category == build_tax_category).to be true }

    it { expect(build_tax_category(exempt: true) != build_tax_category).to be true }
  end

  context "include_exemption_fields" do
    subject(:doc) { tax_category.to_xml(xml, include_exemption_fields: include_exemption_fields) }

    let(:xml)          { Builder::XmlMarkup.new(indent: 2) }
    let(:tax_category) { build_tax_category(exempt: true) }

    context "it is true" do
      let(:include_exemption_fields) { true }

      it "includes TaxExemptionReasonCode and TaxExemptionReason", :aggregate_failures do
        expect(doc).to include("TaxExemptionReasonCode")
        expect(doc).to include("TaxExemptionReason")
      end
    end

    context "it is false" do
      let(:include_exemption_fields) { false }

      it "includes TaxExemptionReasonCode and TaxExemptionReason", :aggregate_failures do
        expect(doc).not_to include("TaxExemptionReasonCode")
        expect(doc).not_to include("TaxExemptionReason")
      end
    end
  end
end
