module MagickTitle

  module Renderer
    
    extend self
    
    # Creates and HTML image tag with the options provided
    def to_html(text, url, opts={})
      opts = { :parent => nil } if opts === false
      opts = { :parent => opts } if opts.is_a?(String)
      opts[:alt] ||= text
      opts.merge!(:src => url)
      parent = opts.delete(:parent)
      tag = %(<img#{hash_to_attributes(opts)}/>)
      if parent
        ptag = parent.is_a?(String) ? parent : parent.is_a?(Hash) ? parent.delete(:tag) : nil
        ptag ||= "h1"
        tag = %(<#{ptag}#{hash_to_attributes(parent)}>#{tag}</#{ptag}>)
      end    
      tag
    end
    
    private
    
      # Converts a hash to a string of html style key="value" pairs
      def hash_to_attributes(hash)
        attributes = []
        return "" unless hash.is_a?(Hash)
        hash.each { |key, value| attributes << %(#{key}="#{value}") if value and 0 < value.length }
        return "" if attributes.length == 0
        " " + attributes.join(" ").strip
      end
      
  end # Renderer
  
end # MagickTitle
