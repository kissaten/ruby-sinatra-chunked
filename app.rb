require 'sinatra'

class Pumatra < Sinatra::Base
  get '/' do
    headers "Transfer-Encoding", "chunked"
    stream do |out|
      out << "It's gonna be legen -\n"
      sleep 0.5
      out << " (wait for it) \n"
      sleep 1
      out << "- dary!\n"
    end
  end
  run! if app_file == $0
end
