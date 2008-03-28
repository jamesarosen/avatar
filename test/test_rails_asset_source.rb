require File.dirname(__FILE__) + '/test_helper.rb'
require 'avatar/source/rails_asset_source'
require 'action_controller/base'

class TestRailsAssetSource < Test::Unit::TestCase
  
  def setup
    ActionController::Base.asset_host = 'http://test.com'
  end
  
  def test_fully_qualified_uri
    source = Avatar::Source::RailsAssetSource.new('http://example.com/images/avatar.png')
    assert_equal 'http://example.com/images/avatar.png', source.avatar_url_for(3)
  end
  
  def test_string_substitution
    source = Avatar::Source::RailsAssetSource.new('http://example.com/images/avatar_#{size}.png')
    assert_equal 'http://example.com/images/avatar_huge.png', source.avatar_url_for(4, {:size => 'huge'})
  end
  
  def test_uses_asset_host
    source = Avatar::Source::RailsAssetSource.new('/images/avatar.png')
    assert_equal 'http://test.com/images/avatar.png', source.avatar_url_for(4)
  end
  
  def test_error_if_cannot_generate_full_uri_and_only_path_false
    ActionController::Base.asset_host = ''
    source = Avatar::Source::RailsAssetSource.new('/images/avatar.png')
    assert_raise(RuntimeError) {
      source.avatar_url_for(4)
    }
  end
  
  def test_no_error_if_cannot_generate_full_uri_and_only_path_true
    ActionController::Base.asset_host = ''
    source = Avatar::Source::RailsAssetSource.new('/images/avatar.png')
    assert_equal '/images/avatar.png', source.avatar_url_for(12, :only_path => true)
  end
  
  def test_no_url_generated_if_person_is_nil
    source = Avatar::Source::RailsAssetSource.new('/images/avatar.png')
    assert_nil source.avatar_url_for(nil)
  end
  
  def test_no_url_generated_if_substitution_incomplete
    source = Avatar::Source::RailsAssetSource.new('/images/avatar_#{size}.png')
    assert_nil source.avatar_url_for(8)
  end
  
end