require 'avatar/string_substitution'
require 'avatar/source/abstract_source'

module Avatar # :nodoc:
  module Source # :nodoc:
    # Like a StaticUrlSource, but allows variable replacement within the string.
    # Usage:
    #   source = StringSubstitutionSource.new('#{gender}_icon_#{size}.png')
    #   url = source.avatar_url_for(@person, :gender => :female, :size => :large)
    #     # => 'female_icon_large.png'
    class StringSubstitutionSource
      include StringSubstitution
      include AbstractSource
      
      attr_accessor :url
      attr_accessor :default_options
      
      # Create a new source with static url +url+, which can contain any number
      # of variables to be subsituted through +options+.  See link:classes/Avatar/StringSubstitution.html
      #
      # Optionally, can pass in +default _options+ to be applied in replacement, overwritable
      # by the +options+ passed to :avatar_url_for.
      def initialize(url, default_options = {})
        raise ArgumentError.new("URL cannot be nil") if url.nil?
        self.url = url.to_s
        self.default_options = default_options || {}
      end
      
      # Returns nil if +person+ is nil or if variables in <code>url</code>
      # remain un-bound after substituting +options+; otherwise, returns
      # the result of replacing each variable within <code>url</code>
      # with the value of the corresponding key within +options+.
      def avatar_url_for(person, options = {})
        return nil if person.nil?
        result = apply_substitution(self.url, self.default_options.merge(options))
        substitution_needed?(result) ? nil : result
      end
      
      def default_options=(opts)
        @default_options = opts || {}
      end
      
    end
  end
end