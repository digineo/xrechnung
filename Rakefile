require "pathname"
require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task default: :spec

VALIDATOR_SOURCES = {
  tool:      {
    filename:    "validator/validator-1.6.0-standalone.jar",
    release_url: "https://github.com/itplr-kosit/validator/releases/download/v1.6.0/validator-1.6.0.zip",
  },
  scenarios: {
    filename:    "validator/scenarios.xml",
    release_url: "https://github.com/itplr-kosit/validator-configuration-xrechnung/releases/download/release-2025-07-10/validator-configuration-xrechnung_3.0.2_2025-07-10.zip",
  },
}.freeze

namespace :validator do
  VALIDATOR_SOURCES.each_value do |v|
    base    = Pathname.new(__dir__).join("validator")
    zipfile = base.join(File.basename(v[:release_url]))

    file zipfile do
      require "httparty"

      base.mkpath unless base.exist?

      res = HTTParty.get(v[:release_url], follow_redirects: true)
      File.open(zipfile, "wb") { |f| f.write res.body }
    end

    file v[:filename] => zipfile do
      require "zip"

      Zip::File.foreach(zipfile) do |entry|
        entry.extract base.join(entry.name)
      end
    end
  end

  desc "Download official validator and scenarios"
  task download: VALIDATOR_SOURCES.map { |_, v| v[:filename] }

  desc "Run validator on test fixtures"
  task run: :download do
    fixtures  = Pathname.new(__dir__).join("spec/fixtures/*.xml")
    output    = Pathname.new(__dir__).join("validator/results").tap(&:mkpath)
    tool      = VALIDATOR_SOURCES[:tool][:filename]
    scenarios = VALIDATOR_SOURCES[:scenarios][:filename]

    sh "java -jar #{tool} -r validator -s #{scenarios} --output-directory #{output} --html #{fixtures}"
  end
end
