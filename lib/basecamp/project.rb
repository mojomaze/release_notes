module Basecamp
  class Project
    
    attr_accessor :name, :status, :id, :company
    
    def initialize(attributes = {})
      parse_xml(attributes[:xml]) if attributes.include? :xml
      @name = attributes[:name] if attributes.include? :name
      @status = attributes[:status] if attributes.include? :status
      @company = attributes[:company] if attributes.include? :company
      @id = attributes[:id] if attributes.include? :id
    end
    
    # returns all projects from a given account
    def self.all(conn)
      projects = []
      self.handle_request(conn) do |p|
        projects << Basecamp::Project.new({:xml => p})
      end
      return projects
    end
    
    # filters returned projects by a given status
    def self.find_by_status(conn, status)
      projects = []
      self.handle_request(conn) do |p|
        projects << Basecamp::Project.new({:xml => p}) if p.at(:status).inner_html == status
      end
      return projects
    end
    
    def self.find(conn, project_id)
      begin
        response = conn.create_request("GET","/projects/#{project_id}.xml")
        doc = Hpricot(response.body)
        elem = doc.at(:project)
        project = Basecamp::Project.new({:xml => elem}) if elem
        return project
      rescue => e
        raise e
      end
    end
    
    private
      def self.handle_request(conn)
        begin
          doc = self.get_projects(conn)
          (doc/"project").each do |p|
            yield p
          end
        rescue => e
          raise e
        end
      end
    
      def self.get_projects(conn)
        begin
          response = conn.create_request("GET","/projects.xml")
          doc = Hpricot(response.body)
        rescue => e
          raise e
        end
      end
    
      def parse_xml(xml)
        @id = xml.at(:id).inner_html.to_i
        @name = xml.at(:name).inner_html
        @status = xml.at(:status).inner_html
        @company = Basecamp::Company.new({ :xml => xml.at(:company) })
      end
  end
end