require 'avatar/source/abstract_source'

module Avatar # :nodoc:
  module Source # :nodoc:
    # Like a StaticUrlSource, but allows variable replacement within the string.
    # Usage:
    #   source = StringSubstitutionSource.new('#{gender}_icon_#{size}.png')
    #   url = source.avatar_url_for(@person, :gender => :female, :size => :large)
    #     # => 'female_icon_large.png'
    class StringSubstitutionSource
      include AbstractSource
      
      attr_accessor :url
      
      # Create a new source with static url +url+, which can contain any number
      # of variables to be subsituted through +options+.  Strings should
      # be of the form '...#{variable_a}...#{variable_b}...'.  <em>note the
      # single quotes</em>; double quotes will cause the variables to be
      # substituted at Source-creation (when #new is called); this is almost
      # certainly <strong>not</strong> what you want.
      def initialize(url)
        raise ArgumentError.new("URL cannot be nil") if url.nil?
        @url = url.to_s
      end
      
      # Returns nil if +person+ is nil or if variables in <code>url</code>
      # remain un-bound after substituting +options+; otherwise, returns
      # the result of replacing each variable within <code>url</code>
      # with the value of the corresponding key within +options+.
      def avatar_url_for(person, options = {})
        return nil if person.nil?
        result = apply_replacement(options)
        result =~ /#\{.*\}/ ? nil : result
      end
      
      private
      
      def apply_replacement(options)
        result = self.url
        options.each do |k,v|
          result = result.gsub(Regexp.new('#\{' + "#{k}" + '\}'), "#{v}")
        end
        result
      end
      
    end
  end
end