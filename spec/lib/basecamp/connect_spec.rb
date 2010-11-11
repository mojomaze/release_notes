require 'spec_helper'

module Basecamp
  
  describe Connect do 
   before(:each) do
     @url = basecamp_url
     @authkey = basecamp_authkey
   end
   
   it "should initialize with passed values" do
     conn = Basecamp::Connect.new( @url, @authkey)
     conn.url.should == @url
     conn.authkey.should == @authkey
   end
   
   describe "create_request" do
    context "Net::HTTP:Get" do
      before do
        @conn = Basecamp::Connect.new( @url, @authkey)
      end
       
      it "should succeed will valid credentials" do
        response = @conn.create_request("Get", "/projects.xml")
        response["status"].should == "200 OK"
      end
      
      it "should raise 401 error with invalid authkey" do
        lambda { 
          @conn.authkey = "thisisnotavalidkey"
          response = @conn.create_request("Get", "/projects.xml")
        }.should raise_error(HTTPError, "Net::HTTPUnauthorized 401 Unauthorized")
      end
      
      it "should raise 301 error without ssl" do
        lambda { 
          @conn.url = basecamp_non_ssl_url
          @conn.ssl = false
          response = @conn.create_request("Get", "/projects.xml")
        }.should raise_error(HTTPError, "Net::HTTPMovedPermanently 301 Moved Permanently")
      end
      
      it "should raise RuntimeError with bogus url " do
        pending("passed but takes too long to timeout" )
        lambda { 
          @conn.url = "https://this.isonephoneyurl.org"
          response = @conn.create_request("Get", "/projects.xml")
        }.should raise_error(RuntimeError)
      end
      
      it "should raise 404 error with invalid url " do
        pending("passed but takes too long to timeout" )
        lambda { 
          @conn.url = basecamp_ugly_url
          response = @conn.create_request("Get", "/projects.xml")
        }.should raise_error(HTTPError, "Net::HTTPNotFound 404 Not Found")
      end
      
    end 
   end
  end
end
