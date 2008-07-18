require 'date'
require 'rake/rdoctask'
require 'rake/testtask'
require 'rake/gempackagetask'

task :default => ['test']

Rake::TaskManager.class_eval do
  def remove_task(task_name)
    @tasks.delete(task_name.to_s)
  end
end

PROJECT_ROOT = File.expand_path(File.dirname(__FILE__))
$: << File.join(PROJECT_ROOT, 'lib')
require 'avatar/version'

LIB_DIRECTORIES = FileList.new do |fl|
  fl.include "#{PROJECT_ROOT}/lib"
  fl.include "#{PROJECT_ROOT}/test/lib/file_column/lib"
end

TEST_FILES = FileList.new do |fl|
  fl.include "#{PROJECT_ROOT}/test/**/test_*.rb"
  fl.exclude "#{PROJECT_ROOT}/test/test_helper.rb"
  fl.exclude "#{PROJECT_ROOT}/test/lib/**/*.rb"
end

Rake.application.remove_task :test

desc 'Run all tests'
Rake::TestTask.new(:test) do |t|
  t.libs = LIB_DIRECTORIES
  t.test_files = TEST_FILES
  t.verbose = true
end

desc "Build a code coverage report"
task :coverage do
  files = TEST_FILES.join(" ")
  sh "rcov -o coverage #{files} --exclude ^/Library/Ruby/,^init.rb --include lib/ --include-file ^lib/.*\\.rb"
end

namespace :coverage do
  task :clean do
    rm_r 'coverage' if File.directory?('coverage')
  end
end

namespace :gem do
    
  spec = Gem::Specification.new do |s|
    s.name = 'avatar'
    s.version = Avatar::VERSION::STRING
    s.summary = 'Multi-source avatar support'
    s.description = "Adds support for rendering avatars from a variety of sources."

    s.specification_version = 2 if s.respond_to? :specification_version=
    s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=

    s.authors = ['James Rosen']
    s.email = 'james.a.rosen@gmail.com'

    s.files = [ 'History.txt', 'License.txt', 'README.txt', 'init.rb', 'rails/init.rb' ] + Dir.glob( "lib/**/*" ).delete_if { |item| item.include?('.git') }

    s.has_rdoc = true
    s.homepage = 'http://github.com/gcnovus/avatar'
    s.rdoc_options = ['--line-numbers', '--inline-source', '--title', 'Grammar RDoc', '--charset', 'utf-8']
    s.require_paths = ['lib']
    s.rubygems_version = '1.1.1'
  end
  
  namespace :spec do
    desc 'writes the spec file to avatar.gemspec'
    task :write do
      File.open(File.join(PROJECT_ROOT, 'avatar.gemspec'), 'w') do |f|
        f << spec.to_ruby
      end
    end
  end
  
  Rake::GemPackageTask.new(spec) do |p|
    p.gem_spec = spec
    p.need_tar = true
    p.need_zip = true
  end
end