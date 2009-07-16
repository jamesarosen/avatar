require File.dirname(__FILE__) + '/test_helper.rb'
require 'avatar/source/pavatar_source'

class TestPavatarSource < Test::Unit::TestCase
  
  def ok_response(body = nil, headers = {})
    r = Net::HTTPOK.new(nil, nil, nil)
    r.stubs(:body).returns(body)
    headers.each { |k,v| r[k] = v }
    r
  end
  
  def mock_http_connection
    conn = Object.new
    factory = Object.new
    factory.stubs(:start).yields(conn)
    @source.http_connection_factory = factory
    conn
  end
  
  def setup
    @source = Avatar::Source::PavatarSource.new
    @gary = Person.new('antono@example.com', 'Antono Vasiljev', 'http://localhost:4567/')
  end
  
  def test_nil_when_person_is_nil
    assert_nil @source.avatar_url_for(nil)
  end
  
  def test_nil_when_person_is_not_nil_but_has_no_profile_url
    @gary.blog_url = nil
    assert_nil @source.avatar_url_for(@gary)
  end
  
  def test_not_nil_when_person_has_an_x_pavatar_header
    avatar_url = 'http://localhost:4567/foo/avatar.png'
    http = mock_http_connection
    http.expects(:head).with('/').returns(ok_response('', { 'X-Pavatar' => avatar_url }))
    assert_equal avatar_url, @source.avatar_url_for(@gary)
  end
  
  def test_not_nil_when_person_has_a_link_rel_pavatar
    avatar_url = 'http://localhost:4567/images/avatar.png'
    http = mock_http_connection
    http.expects(:head).with('/').returns(nil)
    http.expects(:get).with('/').returns(ok_response("<link rel=\"pavatar\" href=\"#{avatar_url}\" />"))
    assert_equal avatar_url, @source.avatar_url_for(@gary)
  end
  
  def test_not_nil_when_person_has_a_pavatar_dot_png_file
    http = mock_http_connection
    http.expects(:head).with('/').returns(nil)
    http.expects(:get).with('/').returns(nil)
    http.expects(:head).with('/pavatar.png').returns(ok_response)
    assert_equal 'http://localhost:4567/pavatar.png', @source.avatar_url_for(@gary)
  end
  
  def test_uses_alternative_connector
    http_factory = Object.new
    http_factory.expects(:start).with('localhost', 4567)
    @source.http_connection_factory = http_factory
    @source.avatar_url_for(@gary)
  end
  
  
end
