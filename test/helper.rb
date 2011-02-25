ENV["environment"] = "test"

require 'test/unit'
#require 'rack/test'
require 'shoulda'
require 'magick_title'
require 'fileutils'

class Test::Unit::TestCase

  def setup
    super
    MagickTitle.options[:root] = File.expand_path("../dummy", __FILE__)
    FileUtils.rm_r MagickTitle.options.destination if Dir.exists?(MagickTitle.options.destination)
  end

end