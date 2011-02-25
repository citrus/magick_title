require 'magick_title/hash'
require 'magick_title/options'
require 'magick_title/image'

module MagickTitle

  extend self
  
  # A shortcut to options[:root]
  def root
    options.root
  end
  
  # Returns the options hash
  def options
    @options ||= Options.new
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
  def image(text, opts={})
    title = ::MagickTitle::Image.new(text, opts)
    title.save unless title.options.cache && File.exists?(title.fullpath)
    title
  end
  alias :say :image
  
end # MagickTitle
