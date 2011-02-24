require 'bundler/setup'
Bundler.require if defined?(Bundler)

include HasImageTitle

use Rack::Static

get '/' do
  erb :index
end

post '/' do
  @image_title = ImageTitle.new(params[:text], params[:options])
  @success = @image_title.save
  erb :index  
end