require 'helper'

class TestMagickTitle < Test::Unit::TestCase

  should "create an instance of MagickTitle::Image" do
    
    @title = MagickTitle.say("Hello Magick Title!")
    
    assert @title.is_a?(MagickTitle::Image)
    assert File.exists?(@title.fullpath)
    
  end
  
  
  
  should "not get cut off" do
    
    @title = MagickTitle.say("HELLO MAGICK TITLE OF DOOM!", :font_path => "/Users/Spencer/Library/Fonts", :font => "HelveticaNeueLTStd-UltLt.otf", :color => "#000000")
    assert File.exists?(@title.fullpath)
    
  end
  
end