require 'avatar/string_substitution'
require 'avatar/source/abstract_source'
require 'action_view/helpers/asset_tag_helper'

module Avatar # :nodoc:
  module Source # :nodoc:
    # Source representing a constant path.  Allows string variable
    # substitution (see link:classes/Avatar/StringSubstitution.html).
    # Good as a default or last-resort source in Rails projects.
    class RailsAssetSource
      include StringSubstitution
      include AbstractSource
      
      attr_accessor :path
      attr_accessor :default_options
      attr_reader :url_helper
      
      private :url_helper
      
      # Create a new source with static path +path+.
      # Raises an error unless +path+ exists.
      # +default_options+ can include any variables
      # to be substituted into +path+ as defaults.
      # Additionally, it can contain the key :only_path,
      # which determines whether a path or full URI is generated
      # by default, :only_path is false.
      def initialize(path, default_options = {})
        raise ArgumentError.new("path cannot be nil") if path.nil?
        self.path = path.to_s
        self.default_options = { :only_path => false }.merge(default_options)
        @url_helper = Object.new
        @url_helper.extend(ActionView::Helpers::AssetTagHelper)
      end
      
      def only_path?
        default_options[:default_path]
      end
      
      def default_options=(opts)
        @default_options = opts || {}
      end
      
      # Returns nil if person is nil; the static path or URI otherwise.
      # Options:
      #  * :only_path (Boolean) - whether to output only the path or a fully-qualified URI; defaults to object-level value
      # Raises an error if both +options[:only_path]+ and the object-level default are both false
      # and the url returned would only be a path.  Try setting
      # <code>ActionController::Base.asset_host</code> to avoid this error.
      #
      # Note: +only_path+ being true is not a guarantee
      # that only a path will be generated; if it is false,
      # however, generated URLs will be full URIs.
      def avatar_url_for(person, options = {})
        return nil if person.nil?
        options = default_options.merge(options)
        path = apply_substitution(self.path, options)
        uri = url_helper.image_path(path)
        raise "could not generate protocol and host for #{uri}" unless uri =~ /^http[s]?\:\/\// || options[:only_path]
        substitution_needed?(uri) ? nil : uri
      end
      
    end
  end
end