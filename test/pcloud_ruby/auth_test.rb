# frozen_string_literal: true
require "pcloud_ruby_test"
module PcloudRuby
  class AuthTest < PcloudRubyTest

  #TODO Controlar de alguna manera para evitar baneo

    def test_get_digest
      auth_aux = Auth.new(email= "test", password= "test") # Valid email&pass not needed to require the digest
      auth_aux.get_digest
      assert_equal 60, auth_aux.digest.length
    end
    
    def test_login_and_logout
      authenticate!
      assert auth
      assert auth.logout
    end

    def test_list_tokens
      authenticate!
      assert auth.list_tokens
    end

    def test_delete_ruby_tokens
      authenticate!
      b = auth.delete_ruby_tokens
      c = auth.list_tokens
      assert c
    end if false
    

  end
end
