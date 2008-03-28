require 'avatar/object_support'

module Avatar # :nodoc:
  
  # Allows runtime variable substitution into a String.
  module StringSubstitution
    
    # For each key in +options+ replaces '#{key}' in +string+ with the
    # corresponding value in +options+.
    # +string+ should
    # be of the form '...#{variable_a}...#{variable_b}...'.  <em>Note the
    # single quotes</em>.  Double quotes will cause the variables to be
    # substituted before this method is run, which is almost
    # certainly <strong>not</strong> what you want.
    def apply_substitution(string, options)
      returning(string.dup) do |result|
        options.each do |k,v|
          result.gsub!(Regexp.new('#\{' + "#{k}" + '\}'), "#{v}")
        end
      end
    end
    
    def substitution_needed?(string)
      string =~ /#\{.*\}/
    end
    
  end
end