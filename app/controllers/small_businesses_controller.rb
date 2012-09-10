class SmallBusinessesController < ApplicationController
     def create
      	@small_business = Refinery::SmallBusinesses::SmallBusiness.create(params[:small_business])
         if @small_business
     	   options    = {:ip=>request.env['REMOTE_ADDR'],:id=>@small_business.id,}
           response   = get_coupon_value(options,"small_business")
      	   redirect_to "/thankyousmallbussinesspage"
         end
      end
end
