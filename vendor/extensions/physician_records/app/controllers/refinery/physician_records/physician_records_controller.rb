module Refinery
  module PhysicianRecords
    class PhysicianRecordsController < ::ApplicationController

      before_filter :find_all_physician_records
      before_filter :find_page

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @physician_record in the line below:
        present(@page)
      end

      def show
        @physician_record = PhysicianRecord.find(params[:id])

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @physician_record in the line below:
        present(@page)
      end
      
      #def create
      #	p "============create"
      #			@physician_record = PhysicianRecord.create(params[:physician_record])
      #			if @physician_record.save
      #				options    = {:ip=>request.env['REMOTE_ADDR'],:id=>@physician_record.id,}
      #  			response = get_coupon_value(options)
      #				redirect_to "/thankyouphysicianspage"
      #			end
      		
     # end

    protected

      def find_all_physician_records
        @physician_records = PhysicianRecord.order('position ASC')
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "/physician_records").first
      end

    end
  end
end
