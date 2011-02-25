require 'bundler/setup'
Bundler.require if defined?(Bundler)


MagickTitle.options = { :font_size => 56 }


use Rack::Static

get '/' do
  erb :index
end

post '/' do
  @image_title = MagickTitle::Image.new(params[:text], params[:options])
  @success = @image_title.save
  erb :index
end