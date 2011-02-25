require 'digest/sha1'
require 'fileutils' unless defined?(FileUtils)

module MagickTitle

  class Image
    
    # The hash of options used for building
    attr_accessor :text
    
    # The hash of options used for building
    # This hash is subclassed as Options and has some fancy features
    attr_accessor :options
    
    # File path to destination folder
    attr_accessor :path  
    
    # Returns the filename of the title
    attr_reader   :filename
    
    # Relative url to the image 
    attr_reader :url
    
    
    # Initializes a new image title with a string
    def initialize(text="", opts={})
      update(text, opts)
      super
    end
    
    
    # updates the image title to reflect new text
    def update(text, opts={})
      @text = text
      return false unless valid?
      @options = (@options || MagickTitle.options).merge(opts.symbolize_keys)
      @filename = filename_from_options #unique_filename(@text)
      @path = options.destination
      @url = File.join((@path.match(/public(\/.*)/) || ['', './'])[1].to_s, @filename)
    end
    
    
    
    # saves title and generates image
    def save
      return false unless valid?
      FileUtils.mkdir_p(path)
      run('convert', title_command_string(fullpath))
      File.exists?(fullpath)
    end
    
    
    # Checks if the image title is valid
    def valid?
      1 < @text.strip.length
    end
    
    
    # Returns the full path to the file
    def fullpath
      File.join(path, filename)
    end
    
    
    # Creates and HTML image tag with the options provided
    def to_html(opts={})
      opts = { :parent => nil } if opts === false
      opts = { :parent => opts } if opts.is_a?(String)
      opts = MagickTitle.options[:to_html].merge(:alt => text, :src => url).merge(opts)
      parent = opts.delete(:parent)
      tag = %(<img #{hash_to_attributes(opts)}/>)
      if parent
        ptag = parent.is_a?(String) ? parent : parent.is_a?(Hash) ? parent.delete(:tag) : nil
        ptag ||= "h1"
        tag = %(<#{ptag} #{hash_to_attributes(parent)}>#{tag}</#{ptag}>)
      end    
      tag
    end
    
    
    # Converts a hash to a string of html style key="value" pairs
    def hash_to_attributes(hash)
      attributes = []
      return attributes unless hash.is_a?(Hash)
      hash.each { |key, value| attributes << %(#{key}="#{value}") if value and 0 < value.length }
      attributes.join(" ").strip
    end
    
    
    private
    
    
      # builds an imagemagick identify command to the specified fild
      def info_command_string(file)
        "-format '%b,%w,%h' #{file}"
      end
      
      # builds an imagemagick command based on the supplied options 
      def title_command_string(file="")
        %(
          -trim
          -antialias
          -background '#{options.background_color}#{options.background_alpha}'
          -fill '#{options.color}'
          -font #{options.font_path}/#{options.font}
          -pointsize #{options.font_size}
          -size #{options.width}x#{options.height}
          -weight #{options.weight}
          -kerning #{options.kerning}
          caption:'#{@text}'
          #{file}
        ).gsub(/[\n\r\s]+/, ' ')
      end 
      
      
      # Cleans and runs the supplied command       
      # (stolen from paperclip)
      def run(cmd, params)
        command = [path_for_command(cmd), params.to_s.gsub(/\\|\n|\r/, '')].join(" ")
        puts command if options.log_command
        `#{command}`
      end 
      
      
      # returns the `bin` path to the command
      def path_for_command(command)
        path = [options.command_path, command].compact
        File.join(*path)
      end
      
      # dev!
      # Creates a filename token based on the title's options
      def filename_from_options
        digest = Digest::SHA1.hexdigest(title_command_string)
        "#{unique_filename}_#{digest}.#{options.extension}"
      end
      
      
      
      # converts the text to a useable filename
      ## defaults to a random string if the filename is blank after replacing illegal chars
      def fileize_text(text)
        text = text[0..31] if 32 < text.length
        file = text.to_s.downcase.gsub(/[^a-z0-9\s\-\_]/, '').strip.gsub(/[\s\-\_]+/, '_')
        #unless 0 < file.length
        #  o =  [('a'..'z'),('0'..'9')].map{|i| i.to_a}.flatten
        #  file = (0..31).map{ o[rand(o.length)]  }.join
        #end
        file
      end
      
      
      
      # creates a unique filename for the title's text
      def unique_filename
        file = fileize_text(@text)
        exists = exists_in_destination? file
        dupe, count = nil, 0
        while exists do
          count += 1
          dupe = "#{file}_#{count}"
          exists = exists_in_destination? dupe
        end
        "#{dupe || file}" # .#{options.extension}"
      end
      
      
      # Checks if file exists in the destination option
      def exists_in_destination?(file)
        file = [file, options.extension].join(".") unless file.match(/\.[a-z]{3,4}$/)
        File.exists?(File.join(options.destination, file))
      end
          
  end # Image
  
end # MagickTitle