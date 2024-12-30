require "spec_helper"
load("spec/fixtures/ruby/additional_document_reference.rb")

RSpec.describe Xrechnung::AdditionalDocumentReference do
  it "generates xml" do
    expect_xml_eq_fixture(build_additional_document_reference, "additional_document_reference")
  end
end
