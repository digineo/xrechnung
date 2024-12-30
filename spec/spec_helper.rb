require "bundler/setup"
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
  path   = "spec/fixtures/scraps/#{fixture_base_name}.xml"
  actual = to_xml(entity)

  File.open(path, "w") { _1 << actual } if ENV["WRITE_FIXTURES"] == "1"
  expect(actual).to eq File.read(path)
end
