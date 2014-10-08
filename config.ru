require 'rubygems'
require 'rack'
require 'base64'
require 'rack/server'
require 'nokogiri'         

class EnvInspector
 	def self.call(env)
    	request = Rack::Request.new env
    	@name=request.params["path"]
  		@name.prepend("/home/")
  		@result="";

		 if File::directory?((@name.to_s))
  		      Dir.foreach(@name) do |item|
  		      fname = item
          		      if fname.match(/([^\s]+(\.(?i)(jpg|png|gif|bmp))$)/)
          		    	      file = File.open("#{@name}/#{item}")
          		    	      data = file.read
          		            img_encoded = Base64.encode64(data)
          		    	      items = "<img src='data:image/*;base64, #{img_encoded}' width= 100px height=100px/>"
          		            @result =@result + "<li  class=\"list-group-item\">#{items}</li>"
        		          
                    else
                         @result=@result + "<li>#{item}</li>"
                    end
              end
                          @result.prepend("<ul>");
      		              	@result+="</ul>";
      	               		[200, {"Content-Type"=>"text/html"},["#@result"]]


       else

                    [200, {"Content-Type"=>"text/html"},["No file in this directory"]]

		 end			
  end
end

Rack::Server.start :app => EnvInspector
