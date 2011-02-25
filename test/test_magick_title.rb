require 'helper'

class TestMagickTitle < Test::Unit::TestCase

  should "create an instance of MagickTitle::Image" do
    
    @title = MagickTitle.say("Hello Magick Title!")
    
    assert @title.is_a?(MagickTitle::Image)
    assert File.exists?(@title.fullpath)
    
  end
  
end