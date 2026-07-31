require "bundler/setup"
require "debug"
require "xrechnung"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def to_xml(entity)
  entity.to_xml(Builder::XmlMarkup.new(indent: 2))
end

def expect_xml_eq_fixture(entity, fixture_base_name)
  expect(to_xml(entity)).to match_fixture("scraps/#{fixture_base_name}")
end

RSpec::Matchers.define :match_fixture do |filename|
  path = "spec/fixtures/#{filename}.xml"

  match do |actual|
    # Update fixtures?
    File.write(path, actual) if ENV["WRITE_FIXTURES"] == "1"

    @expected = File.read(path)
    actual == @expected
  end

  diffable
  attr_reader :expected
end
