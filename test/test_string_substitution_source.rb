require File.dirname(__FILE__) + '/test_helper.rb'
require 'avatar/source/string_substitution_source'

class TestStringSubstitutionSource < Test::Unit::TestCase
  
  def setup
    @source = Avatar::Source::StringSubstitutionSource.new('#{a} and #{b} but not {b}')
  end
  
  def test_avatar_url_nil_for_nil_person
    assert_nil @source.avatar_url_for(nil)
  end
  
  def test_avatar_url_nil_when_not_all_variables_replaced
    assert_nil @source.avatar_url_for(:bar, :b => 'ham')
  end
  
  def test_avatar_url_when_all_variables_replaced
    assert_equal 'green eggs and ham but not {b}', @source.avatar_url_for(:bar, :a => 'green eggs', :b => 'ham')
  end
  
end