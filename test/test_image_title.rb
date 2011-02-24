require 'helper'

class TestImageTitle < Test::Unit::TestCase

  include HasImageTitle

  def setup
    # nothing!
    HasImageTitle.options[:root] = File.expand_path("../dummy", __FILE__)
  end

  should "not allow empty string" do
    @title = ImageTitle.new("")
    assert !@title.valid?
    assert !@title.save
  end
  
  context "a valid image title" do
    
    setup do
      @title = ImageTitle.new("hello")
    end
    
    should "allow valid string" do
      assert @title.valid?
    end
    
    should "save a valid title" do
      assert @title.save
    end
        
  end
  
end