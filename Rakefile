require "bundler/gem_tasks"
require 'rake/testtask'

desc "Run all tests"
Rake::TestTask.new do |t|
   t.libs << "test"
   t.test_files = FileList['test/**/*test.rb']
   t.verbose = true
 end

desc "the default task"
task :default => :test