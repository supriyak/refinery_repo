class PhysiciansController < ApplicationController
 def create
      	p "============create"
      			@physician_record = Refinery::PhysicianRecords::PhysicianRecord.create(params[:physician_record])
      			if @physician_record.save
      				options    = {:ip=>request.env['REMOTE_ADDR'],:id=>@physician_record.id,}
        			response = get_coupon_value(options)
      				redirect_to "/thankyouphysicianspage"
      			end

      end
end