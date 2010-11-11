class User < ActiveRecord::Base
  has_many :releases
  
  serialize :prefs
  
  acts_as_authentic
  
  def preferences
    return self.prefs if self.prefs.kind_of? Hash
    build_prefs
  end
   
  private
  
  def build_prefs
    prefs = {
      :basecamp_authkey => nil,
      :basecamp_url => nil
    }
  end
end
