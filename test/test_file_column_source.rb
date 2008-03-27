require File.join(File.dirname(__FILE__), 'test_helper.rb')
require 'file_column'
require 'avatar/source/file_column_source'

class User < ActiveRecord::Base
  file_column :avatar
  file_column :icon
end

class TestFileColumnSource < Test::Unit::TestCase
  
  def setup
    @source = Avatar::Source::FileColumnSource.new
    png = File.new(File.join(File.dirname(__FILE__), ['lib', 'user_suit.png']))
    @user_with_avatar = User.create!(:email => 'joe@example.com', :avatar => png)
    @user_with_icon = User.create!(:email => 'terry@example.com', :icon => png)
    @user_without_avatar = User.create!(:email => 'sue@example.com')
  end
  
  def test_avatar_url_is_nil_if_person_is_nil
    assert_nil @source.avatar_url_for(nil)
  end
  
  def test_avatar_url_is_nil_if_person_has_no_avatar
    assert_nil @source.avatar_url_for(@user_without_avatar)
  end
  
  def test_avatar_url_for_person_with_avatar
    assert_equal "/user/avatar/#{@user_with_avatar.id}/0/user_suit.png", @source.avatar_url_for(@user_with_avatar)
  end
  
  def test_avatar_url_for_person_with_icon_and_custom_file_column_field
    assert_equal "/user/icon/#{@user_with_icon.id}/0/user_suit.png", @source.avatar_url_for(@user_with_icon, :file_column_field => :icon)
  end
  
end
