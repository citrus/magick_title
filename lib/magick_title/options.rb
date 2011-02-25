module MagickTitle

  class Options < Hash
  
  
    # Initializes the options hash with the defaults
    def initialize
      super
      default!
    end
    
    
    # Clears current options and resets to the defaults
    def default!
      clear
      store :root, defined?(::Rails) ? ::Rails.root.to_s : "./"
      merge! defaults
    end


    # A shortcut to [:root]
    def root
      @root ||= fetch(:root)
    end
    
    
    # The default options hash
    def defaults
      {
        :root => "./",
        :font => "HelveticaNeueLTStd-UltLt.otf",
        :font_path => Proc.new{ File.join MagickTitle.root, "fonts" },
        :font_size => 50,
        :destination => Proc.new{ File.join MagickTitle.root, "public/system/titles" },
        :extension => "png",
        :width => 800,
        :height => nil,
        :background_color => '#ffffff',
        :background_alpha => '00',
        :color => '#68962c',
        :weight => 400,
        :kerning => 0,
        :command_path => nil,
        :log_command => false,
        :cache => true,
        :to_html => {
          :parent => {
            :tag   => "h1",
            :class => "image-title"
          },
          :class => "magick-title"
        }
      }
    end
    
    
    # Sets and option and converts its key to a symbol
    def []=(key, value)
      key = key.to_sym
      raise ArgumentError, "MagickTitle::InvalidOption: #{key} is not an available option." unless defaults.keys.include?(key)      
      super(key, value)
    end
    
    
    # Turns the key into a symbol and returns the requested value
    def [](key)
      val = fetch key.to_sym
      val.is_a?(Proc) ? val.call : val
    end
    
    
    # Retrieve a saved setting by dynamically looking up its value in the hash.
    # Call the value if it's a Proc and return nil if the key's value doesn't exist.
    #   
    #   Options[:foo] = "bar"
    #   Options.foo #=> "bar"
    #   Options.fuz #=> method missing error
    #
    def method_missing(method, *args, &block)
      key = method.to_sym
      val = fetch(key) # if has_key? key
      val.nil? ? nil : val.is_a?(Proc) ? val.call : val
    end
    
  end
  
end