require 'sinatra'

module Sinatra
  module Helpers
    class Stream
      def each(&front)
        @front = front
        callback do
          @front.call("0\r\n\r\n")
        end

        @scheduler.defer do
          begin
            @back.call(self)
          rescue Exception => e
            @scheduler.schedule { raise e }
          end
          close unless @keep_open
        end
      end

      def <<(data)
        @scheduler.schedule do
          size = data.to_s.bytesize
          @front.call([size.to_s(16), "\r\n", data.to_s, "\r\n"].join)
        end
        self
      end
    end
  end
end

class Pumatra < Sinatra::Base
  get '/' do
    headers "Transfer-Encoding" => "chunked"
    stream do |out|
      while true do
        out << "It's gonna be legen -\n"
        sleep 0.5
        out << " (wait for it) \n"
        sleep 1
        out << "- dary!\n"
      end
    end
  end
  run! if app_file == $0
end
