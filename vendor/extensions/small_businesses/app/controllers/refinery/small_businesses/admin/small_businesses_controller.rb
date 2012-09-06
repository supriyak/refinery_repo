module Refinery
  module SmallBusinesses
    module Admin
      class SmallBusinessesController < ::Refinery::AdminController

        crudify :'refinery/small_businesses/small_business',
                :title_attribute => 'firstname', :xhr_paging => true

      end
    end
  end
end
