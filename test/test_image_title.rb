require 'helper'

class TestImage < Test::Unit::TestCase

  include MagickTitle

  def setup
    # nothing!
    MagickTitle.options[:root] = File.expand_path("../dummy", __FILE__)
  end

  should "not allow empty string" do
    @title = Image.new("")
    assert !@title.valid?
    assert !@title.save
  end
  
  context "a valid image title" do
    
    setup do
      @title = Image.new("hello")
    end
    
    should "allow valid string" do
      assert @title.valid?
    end
    
    should "save a valid title" do
      assert @title.save
    end
        
  end
  
end