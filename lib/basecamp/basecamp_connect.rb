require "net/https"
require "uri"

module Basecamp
  class Connect
    # mwinkler = 1fab36f21c180ddd7dd10d2d528a0c30c8677d71
    # BASE_URL = "https://sologroupinc.basecamphq.com"
    attr_accessor :url, :authkey, :ssl

    def initialize(url = nil, authkey = nil, ssl = true )
      @url, @authkey, @ssl = url, authkey, ssl
    end

    def create_message(project_id, body)
      response = create_request("POST","/projects/#{project_id}/posts.xml", body)
      if response["status"] == "201 Created"
        message_url = response["location"]
        # send back the id of the newly created message
        md = /(\d*)\./.match(message_url)
        return md[1] if md[1]
      end
      return nil
    end

    def delete_message(message_id)
      if message_id
        response = create_request("DELETE","/posts/#{message_id}.xml")
        if response["status"] == "200 OK"
          return true
        end
      end
      return nil
    end

    def create_request(type, path, body = nil)
      uri = URI.parse("#{@url}#{path}")
      http = Net::HTTP.new(uri.host, uri.port)
      if @ssl
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      
      # All the HTTP 1.1 methods are available.
      # Net::HTTP::Get
      #     Net::HTTP::Post
      #     Net::HTTP::Put
      #     Net::HTTP::Delete
      #     Net::HTTP::Head
      #     Net::HTTP::Options
  
      # The request.
      case type
      when "POST"
        request = Net::HTTP::Post.new(uri.request_uri)
      when "DELETE"
        request = Net::HTTP::Delete.new(uri.request_uri)
      else
        request = Net::HTTP::Get.new(uri.request_uri)
      end

      request.initialize_http_header({"Accept" => "application/xml", "Content-Type" => "application/xml"})
      request.basic_auth(@authkey, "X")
      request.body = body if body
      return http.request(request)
    end
  end
end