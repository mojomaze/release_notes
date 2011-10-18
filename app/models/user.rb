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

# == Schema Information
#
# Table name: users
#
#  id                :integer         not null, primary key
#  username          :string(255)
#  email             :string(255)
#  crypted_password  :string(255)
#  password_salt     :string(255)
#  persistence_token :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  prefs             :text
#

