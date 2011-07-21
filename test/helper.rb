ENV["environment"] = "test"

require 'bundler/setup'
Bundler.require(:default, :test)
require 'shoulda'


class MagickTitle::TestCase < Test::Unit::TestCase

  def setup
    super
    MagickTitle.options[:root] = File.expand_path("../dummy", __FILE__)
    MagickTitle.options[:log_command] = false
    FileUtils.rm_r MagickTitle.options.destination if File.directory?(MagickTitle.options.destination)
  end
  
  def teardown
    # nada
  end
  
  should "do nothing" do
    # nothing
  end

end