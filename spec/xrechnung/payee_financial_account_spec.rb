require "spec_helper"
load("spec/fixtures/ruby/payee_financial_account.rb")

RSpec.describe Xrechnung::PayeeFinancialAccount do
  it "generates xml" do
    expect_xml_eq_fixture(build_payee_financial_account, "payee_financial_account")
  end
end
