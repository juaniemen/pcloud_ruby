# frozen_string_literal: true

require "test_helper"

class PcloudRubyTest < Minitest::Test
  
  TEST_ROOT = "/test"
  
  def test_that_it_has_a_version_number
    refute_nil ::PcloudRuby::VERSION
  end

end
