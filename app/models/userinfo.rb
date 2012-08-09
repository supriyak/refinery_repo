class Userinfo < ActiveRecord::Base
  validates :userid,  :length => { :maximum => 255 }
  validates :vid,  :length => { :maximum => 255 }  
  validates :firstname, :length => { :maximum => 255 }
  validates :email, :length => { :maximum => 255 }
  validates :address1, :length => { :maximum => 255 }
  validates :address2, :length => { :maximum => 255 }
  validates :city, :length => { :maximum => 255 }
  validates :zip, :length => { :maximum => 255 }
  validates :state, :length => { :maximum => 255 }
  validates_format_of :email, :with => /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i, :message => ' must be valid.', :allow_blank => true
  before_save :truncate_strings
  
  def truncate_strings
    self.url = self.url[0..250] if self.url
    self.path = self.path[0..250] if self.path
    self.subsource = self.subsource[0..250] if self.subsource
    self.creative = self.creative[0..250] if self.creative
    self.api_response = self.api_response[0..250] if self.api_response
  end
 
end

