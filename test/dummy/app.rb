require 'bundler/setup'
Bundler.require if defined?(Bundler)

MagickTitle.style :h1 do
  font_size 56
end

MagickTitle.style :h2 do
  font_size 30
  color '#999'
  to_html :parent => { :tag => "h2" }
end

MagickTitle.style :button do
  to_html :parent => false
  color '#555'
  font_size 27
end

use Rack::Static

get '/' do
  if params[:text] && params[:options]
    @image_title = MagickTitle::Image.new(params[:text], params[:options])
    @success = @image_title.save
  end
  @options = params[:options] || MagickTitle.options
  erb :index
end