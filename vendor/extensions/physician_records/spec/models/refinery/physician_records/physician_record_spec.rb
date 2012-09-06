require 'spec_helper'

module Refinery
  module PhysicianRecords
    describe PhysicianRecord do
      describe "validations" do
        subject do
          FactoryGirl.create(:physician_record,
          :firstname => "Refinery CMS")
        end

        it { should be_valid }
        its(:errors) { should be_empty }
        its(:firstname) { should == "Refinery CMS" }
      end
    end
  end
end
