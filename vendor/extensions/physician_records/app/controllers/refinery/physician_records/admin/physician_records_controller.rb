module Refinery
  module PhysicianRecords
    module Admin
      class PhysicianRecordsController < ::Refinery::AdminController

        crudify :'refinery/physician_records/physician_record',
                :title_attribute => 'firstname', :xhr_paging => true               
                
	

      end
    end
  end
end
