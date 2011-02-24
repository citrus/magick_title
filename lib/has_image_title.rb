require 'has_image_title/hash'
require 'has_image_title/options'
require 'has_image_title/image_title'

#require 'has_image_title/builder'
#require 'has_image_title/base'
#require 'has_image_title/image_title' if defined?(ActiveRecord)

module HasImageTitle

  extend self
  
  # Returns the options hash
  def options
    @options ||= Options.new
  end
 
end # HasImageTitle
