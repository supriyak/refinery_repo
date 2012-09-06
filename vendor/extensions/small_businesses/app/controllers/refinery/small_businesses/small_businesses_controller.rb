module Refinery
  module SmallBusinesses
    class SmallBusinessesController < ::ApplicationController

      before_filter :find_all_small_businesses
      before_filter :find_page

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @small_business in the line below:
        present(@page)
      end

      def show
        @small_business = SmallBusiness.find(params[:id])

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @small_business in the line below:
        present(@page)
      end

      #def create
     # 	p "============create"
     # 			@small_business = SmallBusiness.create(params[:physician_record])
     # 			if @small_business.save
      #				options    = {:ip=>request.env['REMOTE_ADDR'],:id=>@small_business.id,}
      #  			response = get_coupon_value(options)
      #				redirect_to "/thankyousmallbussinesspage"
      #			end

     # end

    protected

      def find_all_small_businesses
        @small_businesses = SmallBusiness.order('position ASC')
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "/small_businesses").first
      end

    end
  end
end
