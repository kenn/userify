require 'rake'
require 'rake/testtask'

generators = %w(userify)

namespace :generator do
  desc "Cleans up the test app before running the generator"
  task :cleanup do
    generators.each do |generator|
      FileList["generators/#{generator}/templates/**/*.*"].each do |each|
        file = "test/rails_root/#{each.gsub("generators/#{generator}/templates/",'')}"
        File.delete(file) if File.exists?(file)
      end
    end

    FileList["test/rails_root/db/**/*"].each do |each| 
      FileUtils.rm_rf(each)
    end
    FileUtils.rm_rf("test/rails_root/vendor/plugins/userify")
    FileUtils.mkdir_p("test/rails_root/vendor/plugins")
    userify_root = File.expand_path(File.dirname(__FILE__))
    system("ln -s #{userify_root} test/rails_root/vendor/plugins/userify")
  end

  desc "Run the generator on the tests"
  task :generate do
    generators.each do |generator|
      system "cd test/rails_root && ./script/generate #{generator} && rake db:migrate db:test:prepare"
    end
  end
end

desc "Run the test suite"
task :default => ['test:all', 'test:features']

gem_spec = Gem::Specification.new do |gem_spec|
  gem_spec.name        = "userify"
  gem_spec.version     = "0.1.6"
  gem_spec.summary     = "Super simple authentication system for Rails, using username, email and password."
  gem_spec.email       = "kenn.ejima <at> gmail.com"
  gem_spec.homepage    = "http://github.com/kenn/userify"
  gem_spec.description = "Super simple authentication system for Rails, using username, email and password."
  gem_spec.authors     = ["Kenn Ejima"]
  gem_spec.files       = FileList["[A-Z]*", "{app,config,generators,lib,rails}/**/*"]
end

desc "Generate a gemspec file"
task :gemspec do
  File.open("#{gem_spec.name}.gemspec", 'w') do |f|
    f.write gem_spec.to_yaml
  end
end
