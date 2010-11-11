module Basecamp
  class Company
    
    attr_accessor :name, :id
    
    def initialize(attributes = {})
      parse_xml(attributes[:xml]) if attributes.include? :xml
      @name = attributes[:name] if attributes.include? :name
      @id = attributes[:id] if attributes.include? :id
    end
    
    private
      def parse_xml(xml)
        @id = xml.at(:id).inner_html.to_i
        @name = xml.at(:name).inner_html
      end
  end
end