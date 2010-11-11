module Basecamp
  class Person
    
    attr_accessor :first_name, :last_name, :id
    
    def initialize(attributes = {})
     parse_xml(attributes[:xml]) if attributes.include? :xml
      @first_name = attributes[:first_name] if attributes.include? :first_name
      @last_name = attributes[:last_name] if attributes.include? :last_name
      @id = attributes[:id] if attributes.include? :id
    end
    
    # gets people by passed company_id
    def self.find_by_company(conn, company_id)
      people = self.handle_request(conn, "/companies/#{company_id}/people.xml")
    end
    
    # gets people by passed project_id
    def self.find_by_project(conn, project_id)
      people = self.handle_request(conn, "/projects/#{project_id}/people.xml")
    end
    
    private
      def self.handle_request(conn, path)
        begin
          response = conn.create_request("GET", path)
          doc = Hpricot(response.body)
        rescue => e
          raise e
        end
        people = []
        (doc/"person").each do |p|
          people << Basecamp::Person.new({:xml => p})
        end
        return people
      end
    
      def parse_xml(xml)
        @id = xml.at(:id).inner_html.to_i
        @first_name = xml.at("first-name").inner_html
        @last_name = xml.at("last-name").inner_html
      end
  end
end