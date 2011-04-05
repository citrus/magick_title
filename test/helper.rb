ENV["environment"] = "test"

require 'test/unit'
require 'shoulda'
require 'magick_title'

#require 'rack/test'
#require 'fileutils'

class Test::Unit::TestCase

  def setup
    super
    MagickTitle.options[:root] = File.expand_path("../dummy", __FILE__)
    MagickTitle.options[:log_command] = false
    FileUtils.rm_r MagickTitle.options.destination if Dir.exists?(MagickTitle.options.destination)
  end
  
  def teardown
    # nada
  end

end