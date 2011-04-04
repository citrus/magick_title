require 'helper'

class TestImage < Test::Unit::TestCase

  def assert_opening_tag(html, tag, inline=false)
    assert html.match(Regexp.new("#{'^' unless inline}<#{tag}\s?")), "#{tag} opening tag"
  end
  
  def assert_closing_tag(html, tag, inline=false)
    assert html.match(Regexp.new("</#{tag}>#{'$' unless inline}")), "#{tag} closing tag"
  end
  
  def assert_self_closing_tag(html)
    assert html.match(/\/>$/), "Has self closing tag"
  end
  
  should "create an instance of MagickTitle::Image" do
    @title = MagickTitle::Image.create("created using class method")
  end
  
  context "an invalid title" do
  
    setup do
      @title = MagickTitle::Image.new("")
    end
  
    should "not allow empty string" do
      assert !@title.valid?
      assert !@title.save
      assert !@title.fullpath
    end
    
    should "not allow update" do
      assert !@title.update("")
      assert !@title.save
      assert !@title.fullpath
    end
    
    should "allow update to valid title" do
      assert @title.update("Hello!")
      assert @title.save
      assert File.exists?(@title.fullpath)
    end
    
  end
    
  context "a valid title" do
  
    setup do
      @title = MagickTitle::Image.new("hello!")
    end
    
    should "save and create an image" do
      assert @title.save
      assert @title.fullpath.match(/\.png$/)
      assert File.exists?(@title.fullpath)
    end
    
    should "delete it's image" do
      assert @title.save
      assert @title.delete
      assert !File.exists?(@title.fullpath)
    end
    
    should "downcase the image tag text" do 
      html = @title.to_html(:id => "crazy-test-id", :class => "span-12 last", :alt => "Custom Alt Tags, Yo!", :parent => nil)
      assert_opening_tag html, 'img'
      assert html.match(/id="crazy-test-id"/)
      assert html.match(/class="span-12\slast"/)
      assert html.match(/alt="Custom\sAlt\sTags\,\sYo\!"/)
      assert_self_closing_tag html
    end
    
  end
  
  context "an existing title" do
  
    setup do
      @title = MagickTitle::Image.create("hello!")
    end
    
    should "cache when asked to" do
      # make sure cache is turned ON
      assert @title.options.cache
      mod = File::mtime(@title.fullpath)
      
      # delay for timestamp..
      sleep 1
      
      # make sure we really don't need to update
      assert !@title.dirty?
      @title.save
      
      mod2 = File::mtime(@title.fullpath)
      assert_equal mod, mod2
    end
    
    should "not cache when asked to" do
      # make sure cache is turned OFF
      @title.options[:cache] = false
      assert !@title.options.cache
      mod = File::mtime(@title.fullpath)
      
      # delay for timestamp..
      sleep 1
      
      # make sure we really don't need to update
      assert !@title.dirty?
      @title.save
      
      mod2 = File::mtime(@title.fullpath)
      assert mod != mod2
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
      @title1 = MagickTitle::Image.create("hello!")
      @title2 = MagickTitle::Image.create("hello!", :color => '#000')
      @title3 = MagickTitle::Image.create("hello!", :color => '#000', :font_size => 16)
      @title4 = MagickTitle::Image.create("hello!", :size => 16)
      @title5 = MagickTitle::Image.create("HELLO!")
    end
    
    should "each have uniq filenames" do
      assert @title1.filename != @title2.filename 
      assert @title2.filename != @title3.filename
      assert @title3.filename != @title4.filename
      assert @title4.filename != @title5.filename
      assert @title5.filename != @title1.filename
    end
    
  end
    
  
    
  context "a long or short title" do
    
    should "allow one letter titles" do
      @title = MagickTitle::Image.create("a")
      assert @title.valid?
      assert @title.save
    end
    
    should "truncate filename when long" do
      @title = MagickTitle::Image.create("Quisque commodo hendrerit lorem quis egestas. Maecenas quis tortor arcu. Vivamus rutrum nunc non neque consectetur quis placerat neque lobortis. Nam vestibulum, arcu sodales feugiat consectetur, nisl orci bibendum elit, eu euismod magna sapien ut nibh. Donec semper quam scelerisque tortor dictum gravida. In hac habitasse platea dictumst. Nam pulvinar, odio sed rhoncus suscipit, sem diam ultrices mauris, eu consequat purus metus eu velit. Proin metus odio, aliquam eget molestie nec, gravida ut sapien. Phasellus quis est sed turpis sollicitudin venenatis sed eu odio. Praesent eget neque eu eros interdum malesuada non vel leo. Sed fringilla porta ligula egestas tincidunt. Nullam risus magna, ornare vitae varius eget, scelerisque a libero. Morbi eu porttitor ipsum. Nullam lorem nisi, posuere quis volutpat eget, luctus nec massa. Pellentesque aliquam lacinia tellus sit amet bibendum. Ut posuere justo in enim pretium scelerisque. Etiam ornare vehicula euismod. Vestibulum at.")
      assert @title.filename.length < 100
    end
    
  end
    
  context "a title with quotes" do
  
    should "allow single quotes" do
      @title = MagickTitle::Image.create("It's pretty nifty")
    end
    
    should "allow double quotes" do
      @title = MagickTitle::Image.create('Then he said; "Ruby rocks"')
    end
    
    should "allow mixed quotes" do
      @title = MagickTitle::Image.create(%("Ruby rocks" - it's what she said))
    end
    
    teardown do
      assert @title.valid?
      assert @title.save      
    end
    
  end
    
end