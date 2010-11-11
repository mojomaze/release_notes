module Basecamp
  class Category
    
    attr_accessor :name, :id
    
    def initialize(attributes = {})
     parse_xml(attributes[:xml]) if attributes.include? :xml
      @name = attributes[:name] if attributes.include? :name
      @id = attributes[:id] if attributes.include? :id
    end
    
    # gets categories by passed project_id
    def self.find_by_project(conn, project_id)
      categories = self.handle_request(conn, "/projects/#{project_id}/categories.xml?type=post")
    end
    
    private
      def self.handle_request(conn, path)
        begin
          response = conn.create_request("GET", path)
          doc = Hpricot(response.body)
        rescue => e
          raise e
        end
        cat = []
        (doc/"category").each do |c|
          cat << Basecamp::Category.new({:xml => c})
        end
        return cat
      end
    
      def parse_xml(xml)
        @id = xml.at(:id).inner_html.to_i
        @name = xml.at(:name).inner_html
      end
  end
end