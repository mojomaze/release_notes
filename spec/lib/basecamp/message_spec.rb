require 'spec_helper'

module Basecamp
  describe Message do
    let(:conn) { Basecamp::Connect.new(basecamp_url, basecamp_authkey) }
    
    it "creates a new basecamp message" do
      pending("passed but don't want to create messages every time" )
      body = "<request><post><category-id>#{ basecamp_message_category }</category-id><title>Test Message</title>
                  <body>This is a test deployment message. Thanks.</body></post></request>"
  
      @message = Basecamp::Message.create(conn, basecamp_project, body)
      @message.to_i.should > 0
    end

    it "deletes an existing basecamp message" do
      pending("passed but too destructive" )
      result = Basecamp::Message.delete(conn, 38860954)
      result.should == true
    end
    
  end
end