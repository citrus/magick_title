#! /usr/bin/env ruby
# encoding: UTF-8

require 'helper'

class TestRenderer < MagickTitle::TestCase

  def assert_opening_tag(html, tag, inline=false)
    assert html.match(Regexp.new("#{'^' unless inline}<#{tag}\s?")), "#{tag} opening tag"
  end
  
  def assert_closing_tag(html, tag, inline=false)
    assert html.match(Regexp.new("</#{tag}>#{'$' unless inline}")), "#{tag} closing tag"
  end
  
  def assert_self_closing_tag(html)
    assert html.match(/\/>$/), "Has self closing tag"
  end
  
  context "the renderer by itself" do
  
    should "create the most basic tag" do
      tag = %(<img alt="Hello" src="test.jpg"/>)
      html = MagickTitle::Renderer.to_html("Hello", "test.jpg", false)
      assert_equal tag, html
    end
    
    should "create the most basic tag inside a parent" do
      tag = %(<p><img alt="Hello" src="test.jpg"/></p>)
      html = MagickTitle::Renderer.to_html("Hello", "test.jpg", "p")
      assert_equal tag, html
    end
  
  end  
  
  context "with an existing title" do
  
    setup do
      @title = MagickTitle::Image.create("hello mr. to_html!")
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
  
  
end
