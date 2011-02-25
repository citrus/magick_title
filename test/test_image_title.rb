require 'helper'

class TestImage < Test::Unit::TestCase

  def setup
    MagickTitle.options[:root] = File.expand_path("../dummy", __FILE__)
  end
  
  should "return an image title" do
    @title = MagickTitle.say("hello!")
    assert @title.is_a?(MagickTitle::Image)
    assert File.exists?(@title.fullpath)
  end
  
end