class SmallBusinessesController < ApplicationController
     def create
      	p "============create"
      			@small_business = Refinery::SmallBusinesses::SmallBusiness.create(params[:small_business])
      			if @small_business
     				options    = {:ip=>request.env['REMOTE_ADDR'],:id=>@small_business.id,}
        			response = get_coupon_value(options)
      				redirect_to "/thankyousmallbussinesspage"
      			end

      end
end
