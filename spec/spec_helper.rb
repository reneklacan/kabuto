# -*- encoding : utf-8 -*-

$VERBOSE = nil

if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

require 'pry'
require './lib/kabuto'

RSpec.configure do |config|
  config.order = :random
end
