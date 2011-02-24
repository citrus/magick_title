require 'bundler/setup'
Bundler.require if defined?(Bundler)

include MagickTitle

use Rack::Static

get '/' do
  erb :index
end

post '/' do
  @image_title = Image.new(params[:text], params[:options])
  @success = @image_title.save
  erb :index  
end