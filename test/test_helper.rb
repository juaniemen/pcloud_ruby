# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "pcloud_ruby"
Dir["../lib/pcloud_ruby/*.rb"].each {|file| require file }

require "byebug"


require "minitest/autorun"

require "authentication_test_helper"
include AuthenticationTestHelper
