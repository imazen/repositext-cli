# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "repositext-cli"
  s.version     = '0.0.1'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jo Hund", "Nathanael Jones"]
  s.email       = ["jhund@clearcove.ca", "nathanael.jones@gmail.com"]
  s.homepage    = "http://github.com/imazen/repositext-cli"
  s.summary     = %q{Command line interface for repositext}
  s.description = ""

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency('kramdown')
  s.add_runtime_dependency('repositext-kramdown')
  s.add_runtime_dependency('repositext-validation')
  s.add_runtime_dependency('suspension')
  s.add_runtime_dependency('thor')

  # Test libraries
  s.add_development_dependency('awesome_print')
  s.add_development_dependency('fakefs')
  s.add_development_dependency('rake')
  s.add_development_dependency('minitest')
  s.add_development_dependency('minitest-spec-expect')
end
