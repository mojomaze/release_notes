module Basecamp
  class Message
   
    def self.create(conn, project_id, body)
      response = conn.create_request("POST","/projects/#{project_id}/posts.xml", body)
      if response["status"] == "201 Created"
        message_url = response["location"]
        # send back the id of the newly created message
        md = /(\d*)\./.match(message_url)
        return md[1] if md[1]
      end
      return nil
    end

    def self.delete(conn, message_id)
      if message_id
        response = conn.create_request("DELETE","/posts/#{message_id}.xml")
        if response["status"] == "200 OK"
          return true
        end
      end
      return nil
    end 
    
  end
end