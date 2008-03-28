require File.dirname(__FILE__) + '/test_helper.rb'
require 'avatar/string_substitution'

class TestStringSubstitution < Test::Unit::TestCase
  
  def setup
    @foo = Object.new
    @foo.extend Avatar::StringSubstitution
    @string = 'I don\'t like #{a}, #{b}, or #{c}'
  end
  
  def test_apply_complete_substitution
    assert_equal "I don't like Detroit, jam, or the letter e", @foo.apply_substitution(@string, {:a => 'Detroit', :b => 'jam', :c => 'the letter e'})
  end
  
  def test_apply_incomplete_substitution
    assert_equal 'I don\'t like #{a}, jam, or #{c}', @foo.apply_substitution(@string, {:b => 'jam'})
  end
  
  def test_substitution_not_needed
    assert !@foo.substitution_needed?('foo # bar { baz }# { yoo}')
  end
  
  def test_substitution_needed
    assert @foo.substitution_needed?('foo #{bar} #{baz}')
  end
  
end