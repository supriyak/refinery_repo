module Refinery
  module SmallBusinesses
    class SmallBusiness < Refinery::Core::BaseModel
      self.table_name = 'refinery_small_businesses'

      attr_accessible :firstname, :lastname, :company, :title, :address1, :address2, :city, :state, :zip, :phone, :email, :employees, :position

      acts_as_indexed :fields => [:firstname, :lastname, :company, :title, :address1, :address2, :city, :state, :zip, :phone, :email]

      validates :firstname, :presence => true #, :uniqueness => true
    end
  end
end
