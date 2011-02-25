require 'helper'

class TestImage < Test::Unit::TestCase

  def setup
    MagickTitle.options[:root] = File.expand_path("../dummy", __FILE__)
  end
  

  should "not allow empty string" do
    @title = MagickTitle::Image.new("")
    assert !@title.valid?
    assert !@title.save
  end
  
  
  context "a valid image title" do
    
    setup do
      @title = MagickTitle::Image.new("hello")
    end
    
    should "allow valid string" do
      assert @title.valid?
    end
    
    should "save a valid title" do
      assert @title.save
      assert File.exists?(@title.fullpath)
    end
        
  end
  
end