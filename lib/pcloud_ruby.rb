# frozen_string_literal: true
require 'dotenv'
Dotenv.load(".dotenv_secrets")

require_relative "pcloud_ruby/version"
require_relative "pcloud_ruby/client"
require_relative "pcloud_ruby/auth"
require_relative "pcloud_ruby/resources/file"
require "byebug"


module PcloudRuby
  class Error < StandardError; end
  # Your code goes here...

  
end

