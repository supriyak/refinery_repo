class TransferredDatum < ActiveRecord::Base
  belongs_to :userinfo
  validates :firstname, :presence =>true,  :length => { :maximum => 255 }
  validates :email, :presence =>true,  :length => { :maximum => 255 }
  validates :address1, :presence =>true,  :length => { :maximum => 255 }
  validates :address2, :length => { :maximum => 255 }
  validates :city, :presence =>true
  validates :zip, :presence =>true
  validates :state, :presence =>true
  validates_format_of :email, :with => /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i, :message => ' must be valid.', :allow_blank => true
end
