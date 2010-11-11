require "spec_helper"

module Basecamp
  describe Category do
    let(:conn) { Basecamp::Connect.new(basecamp_url, basecamp_authkey) }
  
    it "should initialize with passed values" do
       cat = Basecamp::Category.new({:name => "foo", :id => 1})
       cat.name.should == "foo"
       cat.id.should == 1
    end
    
    describe "Self.find_by_project" do
      it "should return people from the passed project" do
        cat = Basecamp::Category.find_by_project(conn, basecamp_project)
        cat.each do |c|
          c.name.should_not be_nil
          c.id.should_not be_nil
        end
      end
    end
  end
end
