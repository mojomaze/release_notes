class User < ActiveRecord::Base
  has_many :releases
  
  serialize :prefs, UserPreference
  
  acts_as_authentic
   
  # setup user prefences and default to nil if not populated
   def prefs
     # make sure we always return a UserPreference instance
     if read_attribute(:prefs).nil?
       write_attribute :prefs, UserPreference.new
       read_attribute :prefs
     else
       read_attribute :prefs
     end
   end

   def prefs=(val)
     write_attribute :prefs, val
   end

   def update_preferences(prefs = {})
     prefs.each do |name, value|
       self.prefs.send(name.to_s + '=', value)
       save(false)
     end
   end
end
