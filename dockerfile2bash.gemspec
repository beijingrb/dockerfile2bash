lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dockerfile2bash"

Gem::Specification.new do |spec|
  spec.name          = "dockerfile2bash"
  spec.version       = Dockerfile2bash::VERSION
  spec.authors       = ["B1nj0y"]
  spec.email         = ["idegorepl@gmail.com"]

  spec.summary       = %q{Parse and Convert a Dockerfile to Bash.}
  spec.description   = %q{The Gem can be used to parse and convert a Dockerfile to a Bash script.}
  spec.homepage      = "https://github.com/beijingrb/dockerfile2bash"
  spec.license       = "MIT"

  spec.files         = %w[dockerfile2bash.gemspec] + Dir["*.md", "bin/*", "lib/**/*.rb", "examples/*.sh"]
  spec.executables   = %w[df2sh]
  spec.require_paths = %w[lib]

  spec.add_development_dependency "bundler", "~> 1.16.a"
  spec.add_development_dependency "rake", "~> 10.0"
end
