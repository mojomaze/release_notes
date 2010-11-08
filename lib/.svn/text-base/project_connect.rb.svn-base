require "net/https"
require "uri"

class ProjectConnect
  
  # api.test = 216baa761d6a6cc23ea0fb539a4819366ca5d00e
  # mwinkler = 1fab36f21c180ddd7dd10d2d528a0c30c8677d71
  
  #PROJECT_USER = current_user.basecamp_authkey
  BASE_URL = "http://sologroupinc.basecamphq.com"
  
  
  def self.create_message(auth_key, project_id, body)
    response = self.create_request(auth_key, "POST","/projects/#{project_id}/posts.xml", body)
    if response["status"] == "201 Created"
      message_url = response["location"]
      # send back the id of the newly created message
      md = /(\d*)\./.match(message_url)
      return md[1] if md[1]
    end
    return nil
  end
  
  def self.delete_message(auth_key, message_id)
    if message_id
      response = self.create_request(auth_key, "DELETE","/posts/#{message_id}.xml")
      if response["status"] == "200 OK"
        return true
      end
    end
    return nil
  end
  
  private
  
  def self.create_request(auth_key, type, path, body = nil)
    uri = URI.parse(BASE_URL+path)
    http = Net::HTTP.new(uri.host)
    
    # The request.
    case type
    when "POST"
      request = Net::HTTP::Post.new(uri.request_uri)
    when "DELETE"
      request = Net::HTTP::Delete.new(uri.request_uri)
    else
      request = Net::HTTP::Get.new(uri.request_uri)
    end

    # All the HTTP 1.1 methods are available.
    # Net::HTTP::Get
    #     Net::HTTP::Post
    #     Net::HTTP::Put
    #     Net::HTTP::Delete
    #     Net::HTTP::Head
    #     Net::HTTP::Options

    request.initialize_http_header({"Accept" => "application/xml", "Content-Type" => "application/xml"})
    request.basic_auth(auth_key, "X")
    request.body = body if body
    return http.request(request)
  end
  
end
