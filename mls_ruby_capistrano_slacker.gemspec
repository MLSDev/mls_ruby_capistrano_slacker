# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "mls_ruby_capistrano_slacker"
  spec.version     = '0.0.1'
  spec.authors     = ["Dmytro Stepaniuk"]
  spec.email       = ["stepaniuk@mlsdev.com"]
  spec.homepage    = "https://mlsdev.com"
  spec.summary     = "Notifications about deploys using Capistrano"
  spec.description = "Slack notifications about Capistrano builds"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "'https://mlsdev.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
