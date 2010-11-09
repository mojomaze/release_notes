require 'basecamp/basecamp_connect'
require "hpricot"

module Basecamp
  class BasecampProject
    
    attr_accessor :name, :status, :id, :xml
    
    def initialize(xml = nil)
      @xml = xml
      parse_xml if @xml
    end
    
    def self.all(url, authkey, ssl = true)
      conn = Basecamp::Connect.new(url, authkey, ssl)
      response = conn.create_request("GET","/projects.xml")
      return nil if response["status"] != "200 OK"
      doc = Hpricot(response.body)
      projects = []
      (doc/"project").each do |p|
        projects << BasecampProject.new(p)
      end
      return projects
    end
    
    protected
      def parse_xml
        @id = @xml.at(:id).inner_html.to_i
        @name = @xml.at(:name).inner_html
        @status = @xml.at(:status).inner_html
      end
  end
end