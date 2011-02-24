# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "magick_title/version"

Gem::Specification.new do |s|
  s.name        = "magick_title"
  s.version     = MagickTitle::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Spencer Steffen"]
  s.email       = ["spencer@citrusme.com"]
  s.homepage    = "https://github.com/citrus/magick_title"
  s.summary     = %q{}
  s.description = %q{}

  s.rubyforge_project = "magick_title"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_development_dependency 'shoulda', '2.11.3'
  s.add_development_dependency 'rack-test', '0.5.7'
  s.add_development_dependency 'sinatra', '1.1.0'
  
end