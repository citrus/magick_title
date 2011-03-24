require 'helper'

class TestOptions < Test::Unit::TestCase

  should "raise error on invalid option" do
    
    assert_raise(NoMethodError) do
      MagickTitle.options = { :size => 56 }
    end    
    
    assert_raise(NoMethodError) do
      MagickTitle.option[:size] = 56
    end    

  end
      
end