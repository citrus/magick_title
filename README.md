Magick Title
============

Want beautiful browser-compatible custom-smoothed & kerned fonts? Magick Title delivers just that by using imagemagick to generate titles based on the options you provide.

** ----- under construction! ----- **
   
Usage
-----

Using MagickTitle is easy:

  MagickTitle.say("Hello!").to_html 
  
  # outputs
  # <h1><img src="/system/titles/hello.png" alt="Bienvenida al mundo de 28 Buenos Días " class="magick-title"></h1>

Without the h1 tag: 
  
  MagickTitle.say("Hello!").to_html(false)
  
  # outputs
  # <img src="/system/titles/hello.png" alt="Bienvenida al mundo de 28 Buenos Días " class="magick-title">


To just get an instance of MagickTitle::Image:

  title = MagickTitle.say("Hello!")
  
  puts title.filename #=> "hello.png"
  puts title.url #=> "/system/titles/hello.png"


More to come!

   
To Do
-----

* Write tests
* Write documentation
* Auto ActiveRecord integration (this will be a seperate HasImage gem)
* Clean up and publish demo app


License
-------

Copyright (c) 2011 Spencer Steffen, released under the New BSD License All rights reserved.