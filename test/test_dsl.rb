require 'helper'

class TestDsl < Test::Unit::TestCase

  should "set font" do
    
    MagickTitle.style :h1 do
      font      "PermanentMarker.ttf"
      font_size 50
      width     200
    end
    
    assert MagickTitle.styles.include?(:h1)
    
    puts MagickTitle.say("Styles are awesome!", :h1).to_html
    
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
    
    puts MagickTitle.say("Styles are awesome!", :h2).to_html
    
  end
    
end