Magick Title
============

Want beautiful copyright-protected browser-compatible custom-smoothed & kerned fonts? MagickTitle delivers just that by using [imagemagick](http://www.imagemagick.org/script/index.php) to generate titles based on the options you provide.

** ----- in beta! ----- **
   

Requirements
------------

MagickTitle is framework agnostic but requires [imagemagick](http://www.imagemagick.org/script/index.php) built with [freetype](http://www.freetype.org/).


Installation
------------

As usual, just use the `gem install` command:

    (sudo) gem install magick_title
    
Or add magick_title as a gem in your Gemfile:

    gem 'magick_title', '>= 0.1.7' 

Then run `bundle install`



Usage
-----

Using MagickTitle is easy. In it's simplest form, it can be used like so:

    MagickTitle.say("Hello")

This will create an image of the word "Hello" with all of the default options. These options can be set globally or on the fly. 

Customize your global title styles by setting MagickTitle's default options while loading your app. If your using rails, it's best to do this in `config/initializers/magick_title.rb`. 

    # Here's the defaults
    MagickTitle.options = {
      :root => "./",
      :font => "PermanentMarker.otf",
      :font_path => Proc.new{ File.join MagickTitle.root, "fonts" },
      :font_size => 50,
      :destination => Proc.new{ File.join MagickTitle.root, "public/system/titles" },
      :extension => "png",
      :width => 800,
      :height => nil,  # setting to nil or 0 will trim to minimum height
      :background_color => '#ffffff',
      :background_alpha => '00',
      :color => '#68962c',
      :weight => 400,
      :kerning => 0,
      :command_path => nil,
      :log_command => false,
      :cache => true,
      :to_html => {
        :parent => {
          :tag   => "h1",
          :class => "image-title"
        },
        :class => "magick-title"
      }
    }
    
Set as few or as many options as you'd like. Your custom options will get merged into the defaults... You can also set individual options like this:

    MagickTitle.options[:font] = 'Lobster.ttf'
    
      
Once you've set your options to your liking, just create a title like so:

    MagickTitle.say("Hello!").to_html 
    
    #=> <h1 class="image-title"><img class="magick-title" alt="Hello!" src="/system/titles/hello_8e05f22657a3573d8fc6fa8115fecfc0812d82be.png"/></h1>


Place the image title in a div rather than an h1:

    MagickTitle.say("Hello!").to_html("div")
    
    #=> <div><img class="magick-title" alt="Hello!" src="/system/titles/hello_f76179c852bb2fa264b8ad2c0c9ceeb9f99dfc0b.png"/></div>


Or without the h1 tag: 
  
    MagickTitle.say("Hello!").to_html(false)
    
    #=> <img class="magick-title" alt="Hello!" src="/system/titles/hello_f76179c852bb2fa264b8ad2c0c9ceeb9f99dfc0b.png"/>


To just get an instance of MagickTitle::Image:

    title = MagickTitle.say("Hello!")
    
    puts title.filename #=> "hello.png"
    puts title.url #=> "/system/titles/hello.png"


Or set some options on the fly:

    MagickTitle.say("Hello!", :font_size => 24, :color => '#ff0000').to_html
    
    #=> <h1 class="image-title"><img class="magick-title" alt="Hello!" src="/system/titles/hello_080fb04470589c55cd0e22c3229d2006baa05f7d.png"/></h1>
    
Note how the token is different than the previous 'Hello!' titles since we've set custom options.
    
    
The html helper can also be customized:

    MagickTitle.say("Hello!").to_html(:class => "custom-title", :parent => { :tag => "h3", :id => "maaaagick" })
    
    #=> <h3 id="maaaagick"><img class="custom-title" alt="Hello!" src="/system/titles/hello_f76179c852bb2fa264b8ad2c0c9ceeb9f99dfc0b.png"/></h3>


Combine no-parent with custom attributes:

    MagickTitle.say("Hello!").to_html(:class => "custom-title", :parent => nil)
     
    #=> <img class="custom-title" alt="Hello!" src="/system/titles/hello_f76179c852bb2fa264b8ad2c0c9ceeb9f99dfc0b.png"/>


To make sure all titles are the same height:

    MagickTitle.say("HELLO!", :height => 50).to_html
    MagickTitle.say("lowercase j's!", :height => 50).to_html
    
     
    
### More to come!


   
To Do
-----

* Write more tests
* Write DSL for options (in progress)
* Support for multiple preset styles (`MagickTitle.say("Hello!", :subtitle)` or `MagickTitle.say("Hello!", :sidebar_title)`) (in progress)
* Smart option validation (:color => 'fff' converts to :color => '#fff' and :color => 'pink' fails)
* More documentation
* Auto ActiveRecord integration (`has_magick_title` class method)
* Heroku support / tempfiles / base64
* Clean up and publish demo app


License
-------

Copyright (c) 2011 Spencer Steffen, released under the New BSD License All rights reserved.