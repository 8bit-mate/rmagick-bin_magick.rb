# frozen_string_literal: true

require_relative "lib/rmagick/bin_magick/version"

Gem::Specification.new do |spec|
  spec.name          = "rmagick-bin_magick"
  spec.version       = Magick::BinMagick::VERSION
  spec.authors       = ["Mate"]

  spec.summary       = "A tiny gem to create binary images (using RMagick)."
  spec.homepage      = "https://github.com/8bit-mate/rmagick-bin_magick.rb"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.0.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org/"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/8bit-mate/rmagick-bin_magick.rb/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features|data)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rmagick", "~> 5.2", ">= 5.2.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
