require 'magick_title/hash'
require 'magick_title/options'
require 'magick_title/image'

#require 'magick_title/builder'
#require 'magick_title/base'
#require 'magick_title/image_title' if defined?(ActiveRecord)

module MagickTitle

  extend self
  
  # Returns the options hash
  def options
    @options ||= Options.new
  end
 
end # MagickTitle
