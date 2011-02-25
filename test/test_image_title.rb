require 'helper'

class TestImage < Test::Unit::TestCase

  def setup
    MagickTitle.options[:root] = File.expand_path("../dummy", __FILE__)
  end
  
  context "a valid title" do
  
    setup do
      @title = MagickTitle.say("hello!")
    end
    
    should "return an image title" do
      assert @title.is_a?(MagickTitle::Image)
      assert File.exists?(@title.fullpath)
    end
    
    should "create an html img tag" do
      tag = @title.to_html
      assert tag.is_a?(String)
      assert tag.match("src=#{@title.url.inspect}")
      assert tag.match("alt=#{@title.text.inspect}")
    end
    
  end
end