Magick Title
============

Want beautiful browser-compatible custom-smoothed & kerned fonts? MagickTitle delivers just that by using imagemagick to generate titles based on the options you provide.

** ----- under construction! ----- **
   
Usage
-----

Using MagickTitle is easy. First, customize your global title styles by setting MagickTitle's default options while loading your app. If your using rails, it's best to do this in `config/initializers/magick_title.rb`. 

      # Here's the defaults

      MagickTitle.options = {
        :root => "./",
        :font => "HelveticaNeueLTStd-UltLt.otf",
        :font_path => Proc.new{ File.join MagickTitle.root, "fonts" },
        :font_size => 50,
        :destination => Proc.new{ File.join MagickTitle.root, "public/system/titles" },
        :extension => "png",
        :width => 800,
        :height => nil,
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
    
    
      # You can also set individual options

      MagickTitle.options[:font] = 'PermanentMarker.ttf'
      
      
Once you've set your options to your liking, just create a title like so:

    MagickTitle.say("Hello!").to_html 
    
    # outputs
    # <h1><img src="/system/titles/hello.png" alt="Bienvenida al mundo de 28 Buenos Días " class="magick-title"></h1>


Place the image title in a div rather than an h1:

    MagickTitle.say("Hello!").to_html("div")
    
    # outputs
    # <div><img src="/system/titles/hello.png" alt="Bienvenida al mundo de 28 Buenos Días " class="magick-title"></div>


Or without the h1 tag: 
  
    MagickTitle.say("Hello!").to_html(false)
    
    # outputs
    # <img src="/system/titles/hello.png" alt="Bienvenida al mundo de 28 Buenos Días " class="magick-title">


To just get an instance of MagickTitle::Image:

    title = MagickTitle.say("Hello!")
    
    puts title.filename #=> "hello.png"
    puts title.url #=> "/system/titles/hello.png"


Or set some options on the fly:

    MagickTitle.say("Hello!", :font_size => 24, :color => '#ff0000')
    
    
The html helper can also be customized:

    MagickTitle.say("Hello!").to_html(:class => "custom-title", :parent => { :tag => "h3", :id => "maaaagick" })
    
    
Combine no-parent with custom :

    MagickTitle.say("Hello!").to_html(:class => "custom-title", :parent => { :tag => "h3", :id => "maaaagick" })
     
    
    
    
More to come!

   
To Do
-----

* Write more tests
* Smart option validation (:color => 'fff' converts to :color => '#fff' and :color => 'pink' fails)
* Better filenames so the same text can have multiple images
* Refactor the `to_html` helper
* More documentation
* Auto ActiveRecord integration (`has_magick_title`)
* Clean up and publish demo app


License
-------

Copyright (c) 2011 Spencer Steffen, released under the New BSD License All rights reserved.