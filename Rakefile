require 'rake'

begin 
  require 'jeweler' 
  Jeweler::Tasks.new do |s| 
    s.name = "nytimes-movies" 
    s.summary = "A gem for talking to the New York Times Movie Reviews API" 
    s.email = "jharris@nytimes.com" 
    s.homepage = "http://github.com/harrisj/nytimes-moves" 
    s.description = "A gem for talking to the New York Times Movie Reviews API" 
    s.authors = ["Jacob Harris"] 
    s.files =  FileList["[A-Z]*", "{bin,generators,lib,test}/**/*"] 
    s.add_dependency 'json' 
  end 
rescue LoadError 
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com" 
end


require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = 'nytimes-articles'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib' << 'test'
  t.pattern = 'test/**/test_*.rb'
  t.verbose = false
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |t|
    t.libs << 'test'
    t.test_files = FileList['test/**/test_*.rb']
    t.verbose = true
  end
rescue LoadError
  puts "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
end

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features)
rescue LoadError
  puts "Cucumber is not available. In order to run features, you must: sudo gem install cucumber"
end

task :default => :test
