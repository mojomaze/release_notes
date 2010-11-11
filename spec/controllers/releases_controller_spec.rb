require 'spec_helper'
require 'basecamp'

describe ReleasesController do
  
  context "When user is not logged in" do
    before do
      logout
    end
    
    it "should redirect without auth" do
      get :index
      response.should redirect_to( root_path )
    end
  end
  
  context "When user is logged in" do
    before do
      login
    end
  
    describe "GET 'index'"do
      it "should redirect without auth" do
        get :index
        response.should be_success
      end
    end
  
    describe "GET 'new'" do  
      it "should be successful" do
        get 'new'
        assigns[:project_list].should_not be_nil
        response.should be_success
      end
    end
  end

end
