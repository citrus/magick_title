module MagickTitle

  class Options < Hash
  
    # Initializes the options hash with the defaults
    def initialize
      super
      default!
    end
    
    # Clears current options and resets to the defaults
    def default!
      clear.merge!(defaults)
    end
    
    # The default options hash
    def defaults
      {
        :root => defined?(Rails) ? Rails.root : "./",
        :field_name => 'title',
        :font => "HelveticaNeueLTStd-UltLt.otf",
        :font_path => "fonts",
        :extension => "png",
        :size => 50,
        :width => 800,
        :height => nil,
        :background_color => '#ffffff',
        :background_alpha => '00',
        :color => '#9a4e9e',
        :weight => 400,
        :kerning => -2,
        :destination => "public/system/titles",
        :command_path => nil,
        :log_command => true,
        :debug => true
      }
    end
    
    # Sets and option and converts its key to a symbol
    def []=(key, value)
      key = key.to_sym
      raise "Invalid Option" unless defaults.keys.include?(key)
      
      if key == :root 
        store(:font_path, File.join(value, "fonts"))
        store(:destination, File.join(value, "pubic/system/titles"))
      end
      
      super(key, value)
    end
    
    # Turns the key into a symbol and returns the requested value
    def [](key)
      super(key.to_sym)
    end
    
  end
  
end