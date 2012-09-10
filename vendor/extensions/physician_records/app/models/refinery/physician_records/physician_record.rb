module Refinery
  module PhysicianRecords
    class PhysicianRecord < Refinery::Core::BaseModel
      self.table_name = 'refinery_physician_records'

      attr_accessible :firstname, :lastname, :practicename, :doctorname, :office_manager, :address1, :address2, :city, :state, :zip, :phone, :fax, :npi_number, :email, :position

      acts_as_indexed :fields => [:firstname, :lastname, :practicename, :doctorname, :office_manager, :address1, :address2, :city, :state, :zip, :phone, :fax, :email]

      validates :firstname, :presence => true#, :uniqueness => true
    end
  end
end
