require 'net/http'
require 'uri'

module Avatar # :nodoc:
  module Source # :nodoc:
    # Implements http://pavatar.com/spec/
    class PavatarSource
      include AbstractSource

      PAVATAR_REGEXP = /(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/pavatar.(png|gif|jpg))?/ix

      # Discovers pavatar URL.  Returns nil if person is nil.
      #
      # Options: 
      # * <code>:pavatar_field (Symbol)</code> - the field to call from person.  By default, <code>:blog_url</code>.
      #
      def avatar_url_for(person, options = {})
        return nil if person.nil?
        options = options.merge! ::Avatar.default_avatar_options
        field = options.delete(:pavatar_field) || :blog_url
        raise ArgumentError.new('No field specified; either specify a default field or pass in a value for :pavatar_field (probably :blog_url)') unless field

        profile_url = person.send(field)
        pavatar_url = nil

        # Autodiscovery
        # http://pavatar.com/spec/#autodiscovery
        uri = URI.parse(profile_url)
        Net::HTTP.start(uri.host, uri.port) do |http|

          # Using http headers
          # http://pavatar.com/spec/#http-header
          resp = http.head('/')
          if resp['X-Pavatar']
            return resp.header['X-Pavatar']

            # Using link element
            # http://pavatar.com/spec/#link-element
            #
          elsif resp = http.get('/') && pavatar_url = parse_html_for_pavatar(resp.body)
            return pavatar_url

            # Using direct URL
            # http://pavatar.com/spec/#direct-url
            #
          elsif resp = http.head('/pavatar.png') && resp.code == 200
            return profile_url + '/pavatar.png'
          else 
            return nil
          end
        end

        if pavatar_url.nil? || pavatar_url.to_s.blank?
          return nil 
        else
          return pavatar_url
        end
      end

      def find_pavatar_url(doc)
        return false if doc.nil? or doc.empty?
        pavatar_url = nil

        # 4.a 2 http://pavatar.com/spec/#autodiscovery-algorithm
        # recommends following regexp /<link rel="pavatar" href="([^""]+)" ?/?>/
        # but it will not always match valid xhtml link element. 
        #
        if result = doc.match(/<link(.+)rel="pavatar"(.+)>/)
          1.upto(2) { |n| pavatar_url = result[n][result.split('"').index { |e| e =~ /http/ }] if result[n] =~ PAVATAR_REGEXP } 
        end
        return pavatar_url
      end

    end
  end
end
