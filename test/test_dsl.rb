require 'helper'

class TestDsl < Test::Unit::TestCase

  should "set font" do
    
    MagickTitle.style :h1 do
      font      "PermanentMarker.ttf"
      font_size 50
      width     200
    end
    
    assert MagickTitle.styles.include?(:h1)
    assert_equal 50, MagickTitle.styles[:h1][:font_size]
    assert_equal 200, MagickTitle.styles[:h1][:width]

  end
  
  
  should "set font style 2" do
    
    MagickTitle.style :h2 do
      font      "Lobster.ttf"
      font_size 30
      color     "#cc0000"
      to_html   :parent => { :tag => "div" }
    end
    
    assert MagickTitle.styles.include?(:h2)
    assert_equal 30, MagickTitle.styles[:h2][:font_size]
    assert_equal "#cc0000", MagickTitle.styles[:h2][:color]
    
  end
    
end