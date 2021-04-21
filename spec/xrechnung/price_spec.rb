require "spec_helper"
load("spec/fixtures/ruby/price.rb")

RSpec.describe Xrechnung::Price do
  it "generates xml" do
    expect_xml_eq_fixture(build_price, "price")
  end
end
