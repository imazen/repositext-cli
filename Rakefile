require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs.push "lib"
  t.libs.push "spec"
  t.pattern = "spec/**/*_spec.rb"
  t.verbose = true
end

task :default => ['test']
