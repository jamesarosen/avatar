require File.dirname(__FILE__) + '/test_helper.rb'
require 'avatar/source/pavatar_source'

class TestPavatarSource < Test::Unit::TestCase
  
  def setup
    @source = Avatar::Source::PavatarSource.new
    @gary = Person.new('antono@example.com', 'Antono Vasiljev', 'http://localhost:4567/')
  end
  
  def test_nil_when_person_is_nil
    assert_nil @source.avatar_url_for(nil)
  end
  
  def test_not_nil_when_person_is_not_nil
    assert_equal 'http://localhost:4567/pavatar.png', @source.avatar_url_for(@gary)
  end
  
  
end
