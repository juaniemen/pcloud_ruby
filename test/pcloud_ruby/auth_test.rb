# frozen_string_literal: true
require "pcloud_ruby_test"

class AuthTest < PcloudRubyTest

#TODO Controlar de alguna manera para evitar baneo

  def test_get_digest
    assert_equal 60, PcloudRuby::Auth.digest.length
  end if false
  
  def test_login_and_logout
    assert auth.login
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
  end
  

end
