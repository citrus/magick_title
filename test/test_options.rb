require 'helper'

class TestOptions < MagickTitle::TestCase

  def setup
    @font_path = MagickTitle.options[:font_path]
  end
  
  def teardown
    MagickTitle.options[:font_path] = @font_path
  end
  
  should "raise error on invalid option" do
    
    assert_raise(NoMethodError) do
      MagickTitle.options = { :size => 56 }
    end    
    
    assert_raise(NoMethodError) do
      MagickTitle.options[:size] = 56
    end    

  end
  
  should "use custom font path" do
    MagickTitle.options[:font_path] = File.expand_path("../dummy/fonts/custom/nested", __FILE__)
    assert File.exists?(File.join(MagickTitle.options[:font_path], "Lobster.ttf"))
    @title = MagickTitle.say("Hello Magick Title with Custom font path!", :font => "Lobster.ttf")
    assert File.exists?(@title.fullpath)
  end
  
end
