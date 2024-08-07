require_relative "lib/xrechnung/version"

Gem::Specification.new do |spec|
  spec.name          = "xrechnung"
  spec.version       = Xrechnung::VERSION
  spec.authors       = ["Julian Kornberger"]
  spec.email         = ["jk+github@digineo.de"]

  spec.summary               = "Library to create invoices in the XRechnung format."
  spec.homepage              = "https://github.com/digineo/xrechnung"
  spec.license               = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.0.0")

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/digineo/xrechnung"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) {
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  }

  spec.require_paths = ["lib"]

  spec.add_dependency "builder", "~> 3.2"

  spec.add_development_dependency "httparty", "~> 0.22"
  spec.add_development_dependency "rubyzip", "~> 2.0"
end
