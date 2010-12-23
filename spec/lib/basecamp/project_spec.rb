require "spec_helper"

module Basecamp
  describe Project do
    let(:conn) { Basecamp::Connect.new(basecamp_url, basecamp_authkey, basecamp_ssl) }
    
    it "should initialize with passed values" do
       project = Basecamp::Project.new({:name => "foo", :status => "bar", :id => 1})
       project.name.should == "foo"
       project.status.should == "bar"
       project.id.should == 1
    end
    
    describe "Self.all" do
      it "returns projects from basecamp" do
        projects = Basecamp::Project.all(conn)
        projects.first.id.should_not == nil
        projects.first.name.should_not == nil
        projects.first.status.should_not == nil
      end
    end
    
    describe "Self.find_by_status" do
      it "should return only projects with passed param" do
        %w{"active", "archived"}.each do |param|
          projects = Basecamp::Project.find_by_status(conn, param)
          projects.each do |p|
            p.status.should == param
          end
        end
      end
    end
    
    describe "Self.find" do
      it "should return a basecamp project with valid project id" do
        project = Basecamp::Project.find(conn, basecamp_project)
        project.id.should_not be_nil
        project.name.should_not be_nil
        project.status.should_not be_nil
        project.company.should_not be_nil
      end
    end
    
  end
end
