require 'bundler'
require 'rake/testtask'

Bundler::GemHelper.install_tasks

Rake::TestTask.new(:test) do |t|
  t.libs << 'test' << 'lib'
  t.verbose = true
end

desc "Default Task"
task :default => [ :test ]