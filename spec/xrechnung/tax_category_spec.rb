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
end
