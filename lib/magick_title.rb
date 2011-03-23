require 'magick_title/hash'
require 'magick_title/options'
require 'magick_title/image'

module MagickTitle

  extend self
  
  def style(name, &block)
    
    opts = Options.new
    opts.instance_eval(&block)    
    styles[:name] = opts
    
  end
  
  
  
  # A shortcut to options[:root]
  def root
    options.root
  end
  
  # Returns the options hash
  def options
    @options ||= Options.new
  end
  
  
  # Returns the styles hash
  def styles
    @styles ||= {}
  end
  
  
  # Sets the options hash
  def options=(value)
    raise ArgumentError, "Magick Title options must be a Hash" unless value.is_a?(Hash)
    value.each_pair do |key, value|
      options[key] = value
    end
    options
  end
 
  # A helper tag to create or fetch and image title
  #
  #   MagickTitle.image("Hello!")
  #   MagickTitle.say("Hi", :refresh => true)
  #
  def image(*args)
    MagickTitle::Image.create(*args)
  end
  alias :say :image
  
end # MagickTitle
