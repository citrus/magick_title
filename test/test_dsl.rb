require 'helper'

class TestDsl < Test::Unit::TestCase

  should "set font" do
    
    MagickTitle.style :h1 do
      font      "Helvetica"
      font_size 10
      width     100
    end
    
    assert_equal 1, MagickTitle.styles.length
    
  end
    
end