# frozen_string_literal: true

require_relative "lib/active_record_anonymizer/version"

Gem::Specification.new do |spec|
  spec.name = "active_record_anonymizer"
  spec.version = ActiveRecordAnonymizer::VERSION
  spec.authors = ["Keshav Biswa"]
  spec.email = ["keshavbiswa21@gmail.com"]

  spec.summary = "Anonymize your ActiveRecord attributes with ease."
  spec.description = <<-DESC
    A Rails gem to anonymize ActiveRecord attributes using Faker and other strategies.
  DESC

  spec.homepage = "https://github.com/keshavbiswa/active_record_anonymizer"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.7"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 5.2.0"
  spec.add_dependency "activesupport", ">= 5.2.0"
  spec.add_dependency "faker", ">= 2.9"
  spec.add_dependency "zeitwerk", "~> 2.4"
end
