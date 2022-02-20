# frozen_string_literal: true
require "pcloud_ruby_test"

module PcloudRuby
  module Resources
    class FileTest < PcloudRubyTest

    #TODO Controlar de alguna manera para evitar baneo

      def test_upload
        authenticate!
        file = ::File.new("test/fixtures/dummy_files/upload_test.txt")
        f = File.upload(TEST_ROOT, file, auth)
        assert f
      end

      def test_upload_remote
        authenticate!
        f = File.upload_remote("https://upload.wikimedia.org/wikipedia/commons/4/49/Koala_climbing_tree.jpg", "/test", auth)
        assert f
      end

      def test_download
        authenticate!
        f = File.download("/test/Koala_climbing_tree.jpg", "test/fixtures/dummy_files/Koala.jpg", auth)
        assert f
      end

      def test_check_upload_progress
        authenticate!
        file = ::File.new("test/fixtures/dummy_files/upload_test.txt")
        f = File.upload(TEST_ROOT, file, auth)
        m = File.check_upload_progress(f["progress_hash"], auth)
        assert m
      end

      def test_delete
        authenticate!
        file = ::File.new("test/fixtures/dummy_files/upload_delete.txt")
        f = File.upload(TEST_ROOT, file, auth)
        f = File.delete(TEST_ROOT+"/upload_delete.txt", auth)
        assert f
      end

      def test_rename
        authenticate!
        file = ::File.new("test/fixtures/dummy_files/other_dummy_file.txt")
        f = File.upload(TEST_ROOT+ "/1", file, auth)
        f = File.rename(TEST_ROOT+"/1/other_dummy_file.txt", TEST_ROOT+"/2/other_dummy_file2.txt", auth)
        assert f
      end
      

    end
  end
end
