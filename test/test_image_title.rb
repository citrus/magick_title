require 'helper'

class TestImage < Test::Unit::TestCase

  def setup
    MagickTitle.options[:root] = File.expand_path("../dummy", __FILE__)
  end
  
  def assert_opening_tag(html, tag, inline=false)
    assert html.match(Regexp.new("#{'^' unless inline}<#{tag}\s?")), "#{tag} opening tag"
  end
  
  def assert_closing_tag(html, tag, inline=false)
    assert html.match(Regexp.new("</#{tag}>#{'$' unless inline}")), "#{tag} closing tag"
  end
  
  def assert_self_closing_tag(html)
    assert html.match(/\/>$/), "Has self closing tag"
  end
  
  context "a valid title" do
  
    setup do
      @title = MagickTitle.say("hello!")
    end
    
    should "return an image title" do
      assert @title.is_a?(MagickTitle::Image)
      assert @title.fullpath.match(/\.png$/)
      assert File.exists?(@title.fullpath)
    end
    
    should "create an html img tag without a parent element" do
      html = @title.to_html(false)
      assert html.is_a?(String)
      assert_opening_tag html, 'img'
      assert html.match("src=#{@title.url.inspect}"), "Sets src to url"
      assert html.match("alt=#{@title.text.inspect}"), "Sets alt to text"
      assert_self_closing_tag html
    end
    
    should "set the parent html container with a string" do
      tag = "h3"
      html = @title.to_html(tag)
      assert_opening_tag html, tag
      assert_closing_tag html, tag
    end
    
    should "defaults the parent html container" do
      tag  = "h1"
      html = @title.to_html(:parent => { :id => "custom_id" })
      assert_opening_tag html, tag
      assert_opening_tag html, 'img', true #inline img tag
      assert_closing_tag html, tag
    end
    
    should "use a different parent container" do
      tag = "div"
      html = @title.to_html(tag)
      assert html.match(/<div></)
    end
    
    should "customize the parent html container" do
      tag = "div"
      html = @title.to_html(:parent => { :tag => tag, :id => "custom_id", :class => "some-class" })
      assert_opening_tag html, tag
      assert html.match(/id="custom_id"/)
      assert html.match(/class="some-class"/)
      assert_closing_tag html, tag
    end
    
    should "customize the image tag" do 
      html = @title.to_html(:id => "crazy-test-id", :class => "span-12 last", :alt => "Custom Alt Tags, Yo!", :parent => nil)
      assert_opening_tag html, 'img'
      assert html.match(/id="crazy-test-id"/)
      assert html.match(/class="span-12\slast"/)
      assert html.match(/alt="Custom\sAlt\sTags\,\sYo\!"/)
      assert_self_closing_tag html
    end
    
  end
  
  context "titles with the same text" do
    
    setup do
      @title1 = MagickTitle.say("hello!")
      @title2 = MagickTitle.say("hello!", :color => '#000')
      @title3 = MagickTitle.say("hello!", :color => '#000', :font_size => 16)
      @title4 = MagickTitle.say("hello!", :size => 16)
      @title5 = MagickTitle.say("HELLO!")
    end
    
    should "each have uniq filenames" do
      assert @title1.filename != @title2.filename 
      assert @title2.filename != @title3.filename
      assert @title3.filename != @title4.filename
      assert @title4.filename != @title5.filename
    end
    
  end
    
  context "a title with long text" do
    
    setup do
      @title = MagickTitle.say("Quisque commodo hendrerit lorem quis egestas. Maecenas quis tortor arcu. Vivamus rutrum nunc non neque consectetur quis placerat neque lobortis. Nam vestibulum, arcu sodales feugiat consectetur, nisl orci bibendum elit, eu euismod magna sapien ut nibh. Donec semper quam scelerisque tortor dictum gravida. In hac habitasse platea dictumst. Nam pulvinar, odio sed rhoncus suscipit, sem diam ultrices mauris, eu consequat purus metus eu velit. Proin metus odio, aliquam eget molestie nec, gravida ut sapien. Phasellus quis est sed turpis sollicitudin venenatis sed eu odio. Praesent eget neque eu eros interdum malesuada non vel leo. Sed fringilla porta ligula egestas tincidunt. Nullam risus magna, ornare vitae varius eget, scelerisque a libero. Morbi eu porttitor ipsum. Nullam lorem nisi, posuere quis volutpat eget, luctus nec massa. Pellentesque aliquam lacinia tellus sit amet bibendum. Ut posuere justo in enim pretium scelerisque. Etiam ornare vehicula euismod. Vestibulum at.")
    end
    
    should "truncate filename" do
      assert @title.filename.length < 100
    end
    
  end
    
end