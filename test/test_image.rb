#! /usr/bin/env ruby
# encoding: UTF-8

require 'helper'

class TestImage < MagickTitle::TestCase
    
  def identify_image(path)
    Hash.create([ :width, :height, :size ], `identify -format '%w,%h,%b' #{path}`.split(",").map(&:to_i))
  end
    
  should "create an instance of MagickTitle::Image" do
    @title = MagickTitle::Image.create("created using class method")
  end
  
  should "set a title's line-height" do
    @title = MagickTitle::Image.create("Default\nLine\nHeight")
    img = identify_image(@title.fullpath)
    assert_equal img[:height], @title.identify[:height]
    
    @title2 = MagickTitle::Image.create("Default\nLine\nHeight", :line_height => -25)
    img2 = identify_image(@title2.fullpath)
    assert_equal img2[:height], @title2.identify[:height]
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
    
  end
  
  
  context "an existing title" do
  
    setup do
      @title = MagickTitle::Image.create("hello!")
    end
    
    should "return convert_command" do
      assert @title.convert_command.match('echo "hello!" | convert')
      assert @title.convert_command.match(/\.png$/)
    end
    
    should "identify its dimensions and size" do
      img = identify_image(@title.fullpath)
      hash = @title.identify
      assert_equal Hash, hash.class
      assert_equal 3, hash.values.length
      assert_equal img[:width], hash[:width]
      assert_equal img[:height], hash[:height]
      assert_equal img[:size], hash[:size]
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
    
    
  context "an unusual title" do
    
    should "allow one letter titles" do
      @title = MagickTitle::Image.create("a")
    end
    
    should "truncate filename when long" do
      @title = MagickTitle::Image.create("Quisque commodo hendrerit lorem quis egestas. Maecenas quis tortor arcu. Vivamus rutrum nunc non neque consectetur quis placerat neque lobortis. Nam vestibulum, arcu sodales feugiat consectetur, nisl orci bibendum elit, eu euismod magna sapien ut nibh. Donec semper quam scelerisque tortor dictum gravida. In hac habitasse platea dictumst. Nam pulvinar, odio sed rhoncus suscipit, sem diam ultrices mauris, eu consequat purus metus eu velit. Proin metus odio, aliquam eget molestie nec, gravida ut sapien. Phasellus quis est sed turpis sollicitudin venenatis sed eu odio. Praesent eget neque eu eros interdum malesuada non vel leo. Sed fringilla porta ligula egestas tincidunt. Nullam risus magna, ornare vitae varius eget, scelerisque a libero. Morbi eu porttitor ipsum. Nullam lorem nisi, posuere quis volutpat eget, luctus nec massa. Pellentesque aliquam lacinia tellus sit amet bibendum. Ut posuere justo in enim pretium scelerisque. Etiam ornare vehicula euismod. Vestibulum at.")
      assert @title.filename.length < 100
    end
    
    should "allow utf8 characters" do
      @title = MagickTitle::Image.create("J'aime Café Chèvre et Crêpes")
    end
    
    should "allow single quotes" do
      @title = MagickTitle::Image.create("It's pretty nifty")
    end
    
    should "allow double quotes" do
      @title = MagickTitle::Image.create('Then he said; "Ruby rocks"')
    end
    
    should "allow mixed quotes" do
      @title = MagickTitle::Image.create(%("Ruby rocks" - it's what she said))
    end
    
    should "allow escaped quotes" do
      @title = MagickTitle::Image.create(%(he said, "\"Ruby rocks\" - it\'s what she said"))
    end
    
    teardown do
      assert @title.valid?
      assert @title.save      
    end
    
  end
  
end
