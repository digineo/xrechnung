require "spec_helper"
load("spec/fixtures/ruby/item.rb")

RSpec.describe Xrechnung::Item do
  it "generates xml" do
    expect_xml_eq_fixture(build_item, "item")
  end
end
