require 'fileutils'
require 'digest/sha1'

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
    
    
    # Creates an instance of MagickTitle::Image
    #
    #   MagickTitle::Image.create("text")
    #   MagickTitle::Image.create("large", :font_size => 60)
    #
    def self.create(*args)
      title = new(*args)
      return unless title.save
      title
    end
    
    
    # Initializes a new image title with a string
    def initialize(text="", opts={})
      update(text, opts)
    end
    
    
    # updates the image title to reflect new text and returns self
    def update(text, opts={})
      @text = text
      return unless valid?
      
      # save the fullpath so we can delete it later
      @old_path = fullpath
      
      @options = (@options || MagickTitle.options).merge(opts.symbolize_keys)
      @filename = filename_from_options #unique_filename(@text)
      @path = options.destination
      @url = File.join((@path.match(/public(\/.*)/) || ['', './'])[1].to_s, @filename)
      self
    end
    
    
    # Saves title and generates image
    def save
      # validate
      return unless valid?
    
      # check for caching
      return true if options.cache && !dirty?
      
      # delete if an old title exists
      delete(@old_path)
      
      # delete current image
      delete(fullpath)
      
      FileUtils.mkdir_p(path)
      
      command = cmd('convert', title_command_string(fullpath))
      command = %(echo "#{@text.gsub('"', '\\"')}" | #{command})
      puts command if options.log_command
      system command
      
      File.exists?(fullpath)
    end
    
    # Deletes the specified image
    def delete(file=fullpath)
      FileUtils.rm(file) if file && File.exists?(file)
    end
    
    
    # Checks if the image title is valid
    def valid?
      0 < @text.strip.length
    end
    
    
    # Checks if the image title needs to be saved
    def dirty?
      !exists? || (@old_path && @old_path != fullpath)
    end
    
    # Checks if the specified file exists
    def exists?(file=fullpath)
      return unless file
      file = [file, options.extension].join(".") unless file.match(/\.[a-z]{3,4}$/)
      File.exists?(file)
    end
    
    # Returns the full path to the file
    def fullpath
      return unless path && filename
      File.join(path, filename)
    end
    
    
    # Creates and HTML image tag with the options provided
    def to_html(opts={})
      opts = { :parent => nil } if opts === false
      opts = { :parent => opts } if opts.is_a?(String)
      opts = options[:to_html].merge(:alt => text, :src => url).merge(opts)
      parent = opts.delete(:parent)
      tag = %(<img#{hash_to_attributes(opts)}/>)
      if parent
        ptag = parent.is_a?(String) ? parent : parent.is_a?(Hash) ? parent.delete(:tag) : nil
        ptag ||= "h1"
        tag = %(<#{ptag}#{hash_to_attributes(parent)}>#{tag}</#{ptag}>)
      end    
      tag
    end
    
    
    # Converts a hash to a string of html style key="value" pairs
    def hash_to_attributes(hash)
      attributes = []
      return "" unless hash.is_a?(Hash)
      hash.each { |key, value| attributes << %(#{key}="#{value}") if value and 0 < value.length }
      " " + attributes.join(" ").strip
    end
    
    
    private
    
    
      # builds an imagemagick identify command to the specified fild
      def info_command_string(file)
        "-format '%b,%w,%h' #{file}"
      end
      
      # builds an imagemagick command based on the supplied options 
      def title_command_string(file="")
        %(
          #{'-trim ' unless 0 < options.height.to_i}
          -antialias
          -background '#{options.background_color}#{options.background_alpha}'
          -fill '#{options.color}'
          -font #{options.font_path}/#{options.font}
          -pointsize #{options.font_size}
          -size #{options.width}x#{options.height}
          -weight #{options.weight}
          -kerning #{options.kerning}
          caption:@-
          #{file}
        ).gsub(/[\n\r\s]+/, ' ')
      end 
      
      def escape_for_convert(string)
        string.gsub(/(['"])/) { |q| "\\#{q}" }
      end
      
            
      # Cleans and runs the supplied command
      def cmd(command, params)
        [path_for_command(command), params.to_s.gsub(/\\|\n|\r/, '')].join(" ")
      end 
      
      
      
      # returns the `bin` path to the command
      def path_for_command(command)
        path = [options.command_path, command].compact
        File.join(*path)
      end
      
      
      # Creates a filename token based on the title's options
      def filename_from_options
        digest = Digest::SHA1.hexdigest([@text, title_command_string].join("--"))
        "#{unique_filename}_#{digest}.#{options.extension}"
      end
      
      
      # Truncates if necessary and converts the text to a useable filename
      def fileize_text(text)
        text = text[0..31] if 32 < text.length
        file = text.to_s.downcase.gsub(/[^a-z0-9\s\-\_]/, '').strip.gsub(/[\s\-\_]+/, '_')
        file
      end
      
      
      
      # creates a unique filename for the title's text
      def unique_filename
        file = fileize_text(@text)
        exists = exists? file
        dupe, count = nil, 0
        while exists do
          count += 1
          dupe = "#{file}_#{count}"
          exists = exists? dupe
        end
        dupe || file
      end
      
          
  end # Image
  
end # MagickTitle