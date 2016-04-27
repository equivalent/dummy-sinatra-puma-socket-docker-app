require 'sinatra/base'

class Pumatra < Sinatra::Base
  get '/' do
    "Hello World!"
  end
end
