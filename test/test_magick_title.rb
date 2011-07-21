require 'helper'

class TestMagickTitle < MagickTitle::TestCase

  should "create an instance of MagickTitle::Image" do
    @title = MagickTitle.say("Hello Magick Title!")
    assert @title.is_a?(MagickTitle::Image)
    assert File.exists?(@title.fullpath)
  end
  
  should "not get cut off" do
    @title = MagickTitle.say("HELLO MAGICK TITLE OF DOOM!", :color => "#000000")
    assert File.exists?(@title.fullpath)
  end
  
end
