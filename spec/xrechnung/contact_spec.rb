require "spec_helper"
load("spec/fixtures/contact.rb")

RSpec.describe Xrechnung::Contact do
  it "generates xml" do
    expect_xml_eq_fixture(build_contact, "contact")
  end
end
