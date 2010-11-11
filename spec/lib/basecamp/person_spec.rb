require "spec_helper"

module Basecamp
  describe Project do
    let(:conn) { Basecamp::Connect.new(basecamp_url, basecamp_authkey) }
  
    it "should initialize with passed values" do
       person = Basecamp::Person.new({:first_name => "foo", :last_name => "bar", :id => 1})
       person.first_name.should == "foo"
       person.last_name.should == "bar"
       person.id.should == 1
    end
    
    describe "Self.find_by_company" do
      it "should return people from the passed company" do
        people = Basecamp::Person.find_by_company(conn, basecamp_company)
        people.each do |p|
          p.first_name.should_not be_nil
          p.last_name.should_not be_nil
          p.id.should_not be_nil
        end
      end
    end
    
    describe "Self.find_by_project" do
      it "should return people from the passed project" do
        people = Basecamp::Person.find_by_project(conn, basecamp_project)
        people.each do |p|
          p.first_name.should_not be_nil
          p.last_name.should_not be_nil
          p.id.should_not be_nil
        end
      end
    end
  end
end
