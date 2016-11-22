require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.warning = false
end

task :dotenv_test do
  require 'dotenv'
  Dotenv.load('.env.test')
end

task :test => :dotenv_test

desc "Run tests"
task :default => :test
