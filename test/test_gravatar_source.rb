require File.dirname(__FILE__) + '/test_helper.rb'
require 'avatar/source/gravatar_source'
require 'avatar/source/static_url_source'
require 'digest/md5'

class TestGravatarSource < Test::Unit::TestCase
  
  def setup
    @source = Avatar::Source::GravatarSource.new
    @gary = Person.new('gary@example.com', 'Gary Glumph')
    @email_hash = Digest::MD5::hexdigest(@gary.email)
  end
  
  def test_nil_when_person_is_nil
    assert_nil @source.avatar_url_for(nil)
  end
  
  def test_not_nil_when_person_is_not_nil
    assert_equal "http://www.gravatar.com/avatar/#{@email_hash}", @source.avatar_url_for(@gary)
  end
  
  def test_field
    name_hash = Digest::MD5::hexdigest(@gary.name)
    assert_equal "http://www.gravatar.com/avatar/#{name_hash}", @source.avatar_url_for(@gary, :field => :name)
  end
  
  def test_site_wide_default_string
    @source.default_source = 'fazbot'
    assert_equal "http://www.gravatar.com/avatar/#{@email_hash}?default=fazbot", @source.avatar_url_for(@gary)
  end
  
  def test_site_wide_default_source
    @source.default_source = Avatar::Source::StaticUrlSource.new('funky')
    assert_equal "http://www.gravatar.com/avatar/#{@email_hash}?default=funky", @source.avatar_url_for(@gary)
  end
  
  def test_site_wide_default_nil
    @source.default_source = Avatar::Source::StaticUrlSource.new('plumb')
    @source.default_source = nil
    assert_equal "http://www.gravatar.com/avatar/#{@email_hash}", @source.avatar_url_for(@gary)
  end

  def test_default_override
    @source.default_source = Avatar::Source::StaticUrlSource.new('does it really matter?')
    assert_equal "http://www.gravatar.com/avatar/#{@email_hash}?default=gonzo", @source.avatar_url_for(@gary, :default => 'gonzo')
  end
  
  def test_size
    assert_equal "http://www.gravatar.com/avatar/#{@email_hash}?size=70", @source.avatar_url_for(@gary, :size => 70)
    assert_equal "http://www.gravatar.com/avatar/#{@email_hash}?size=62", @source.avatar_url_for(@gary, :s => 62)
  end
  
  def test_rating
    assert_equal "http://www.gravatar.com/avatar/#{@email_hash}?rating=R", @source.avatar_url_for(@gary, :rating => 'R')
    assert_equal "http://www.gravatar.com/avatar/#{@email_hash}?rating=PG", @source.avatar_url_for(@gary, :r => 'PG')
  end
  
end
