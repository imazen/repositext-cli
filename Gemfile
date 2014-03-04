source 'http://rubygems.org'

gemspec

# Until we have released these dependencies, we need to put them
# here so that they can be installed from a :path (gemspec doesn't handle this).
# Once they are released and stable, we can remove these entries in the gemfile
# and rely on the dependencies in .gemspec.
gem 'repositext-kramdown', :path => '../repositext-kramdown'
gem 'repositext-validation', :path => '../repositext-validation'
gem 'suspension', :path => '../suspension'

# While we may have pending patches, use local kramdown with patches.
# NOTE: You need to check out the 'gemfile' branch to make it work.
gem 'kramdown', :path => '../kramdown'
