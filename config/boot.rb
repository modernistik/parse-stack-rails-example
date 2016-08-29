ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

puts "Trying Parse-Stack? Make sure you read the README file and run the rails console instead."
