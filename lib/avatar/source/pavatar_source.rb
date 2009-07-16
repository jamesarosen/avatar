require 'net/http'
require 'uri'

module Avatar # :nodoc:
  module Source # :nodoc:
    # Implements http://pavatar.com/spec/
    class PavatarSource
      include AbstractSource

      PAVATAR_REGEXP = /^((?:http|https):\/\/.+)$/ix
      
      attr_accessor :http_connection_factory
      
      # Create a new PAvatar source.
      #
      # Options:
      # * <code>:http_connection_factory</code> - the Object used to start new HTTP connections. By default, 
      #                                           the <code>Net::HTTP</code> class. To use a proxy, pass 
      #                                           <code>:http_connection_factory => Net::HTTP::Proxy(...)</code>
      def initialize(options = {})
        self.http_connection_factory = options.delete(:http_connection_factory) || Net::HTTP
      end

      # Discovers pavatar URL.  Returns nil if person is nil.
      #
      # Options: 
      # * <code>:pavatar_field (Symbol)</code> - the field to call from person.  By default, <code>:blog_url</code>.
      def avatar_url_for(person, options = {})
        return nil if person.nil?
        options = options.merge! ::Avatar.default_avatar_options
        field = options.delete(:pavatar_field) || :blog_url
        raise ArgumentError.new('No field specified; either specify a default field or pass in a value for :pavatar_field (probably :blog_url)') unless field

        pavatar_url = autodiscover_pavatar_url_from person.send(field)
        
        (pavatar_url.nil? || pavatar_url.to_s.blank?) ? nil : pavatar_url
      end
      
      private
      
      # Autodiscover PAvatar URL from a +profile_url+.
      # 
      # See http://pavatar.com/spec/#autodiscovery
      #
      # Returns +nil+ if +profile_url+ is blank.
      def autodiscover_pavatar_url_from(profile_url)
        return nil if profile_url.blank?
        uri = URI.parse(profile_url)
        begin
          self.http_connection_factory.start(uri.host, uri.port) do |http|
            return avatar_from_header(http) || avatar_from_link_element(http) || direct_avatar(profile_url, http) || nil
          end
        rescue Errno::ECONNREFUSED => e
          nil
        end
      end
      
      
        # Autodisciover using http headers.
        #
        # See http://pavatar.com/spec/#http-header
        #
        # Returns the URL if found; +nil+ otherwise.
        def avatar_from_header(http)
          resp = http.head('/')
          resp.kind_of?(Net::HTTPSuccess) && resp['X-Pavatar']
        end
      
      
        # Autodiscover using link element.
        #
        # See http://pavatar.com/spec/#link-element
        #
        # Returns the URL if found; +nil+ otherwise.
        def avatar_from_link_element(http)
          resp = http.get('/')
          resp.kind_of?(Net::HTTPSuccess) && parse_html_for_pavatar(resp.body)
        end
        
        
          # Look for a <link rel='pavatar' href='...' />
          #
          # Returns the URL if found; +nil+ otherwise.
          def parse_html_for_pavatar(doc)
            return nil if doc.nil? or doc.empty?

            # 4.a 2 http://pavatar.com/spec/#autodiscovery-algorithm
            # recommends following regexp /<link rel="pavatar" href="([^""]+)" ?/?>/
            # but it will not always match valid xhtml link element. 
            #
            if result = doc.match(/<link(.+)rel=["']pavatar["'](.+)>/)
              result.to_a[1..-1].map { |s| s.split(/["']/) }.flatten.find { |url| url =~ PAVATAR_REGEXP }
            end
          end
      
      
        # Autodiscover using direct URL.
        #
        # See http://pavatar.com/spec/#direct-url
        #
        # Returns the URL if found; +nil+ otherwise.
        def direct_avatar(profile_url, http)
          resp = http.head('/pavatar.png')
          profile_url + (profile_url =~ /\/$/ ? '' : '/') + 'pavatar.png' if resp.kind_of?(Net::HTTPSuccess)
        end

    end
  end
end
