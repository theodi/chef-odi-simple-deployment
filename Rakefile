#!/usr/bin/env rake

desc "Runs foodcritic linter"
task :foodcritic do
  Rake::Task[:prepare_sandbox].execute

  if Gem::Version.new("1.9.2") <= Gem::Version.new(RUBY_VERSION.dup)
    sh "foodcritic -f any #{sandbox_path}"
  else
    puts "WARN: foodcritic run is skipped as Ruby #{RUBY_VERSION} is < 1.9.2."
  end
end


namespace :knife do

  desc "Runs knife cookbook test"
  task :test do
    Rake::Task[:prepare_sandbox].execute
    sh "bundle exec knife cookbook test cookbook -c test/.chef/knife.rb -o #{sandbox_path}/../"
  end

end

namespace :berkshelf do

  desc "Upload cookbook to chef server"
  task :upload do
    sh "bundle exec berks upload -c deploy/berkshelf.json"
  end

end

namespace :kitchen do

  desc "Run test-kitchen tests"
  task :test do
    sh "kitchen test"
  end

end

task :default => ['foodcritic', 'knife:test', 'kitchen:test']

task :prepare_sandbox do
  files = %w{*.md *.rb attributes definitions files libraries providers recipes resources templates}

  rm_rf sandbox_path
  mkdir_p sandbox_path
  cp_r Dir.glob("{#{files.join(',')}}"), sandbox_path
end

private

def sandbox_path
  File.join(File.dirname(__FILE__), %w(tmp cookbooks cookbook))
end
