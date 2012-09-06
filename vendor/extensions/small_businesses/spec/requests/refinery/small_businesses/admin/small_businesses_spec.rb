# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "SmallBusinesses" do
    describe "Admin" do
      describe "small_businesses" do
        login_refinery_user

        describe "small_businesses list" do
          before do
            FactoryGirl.create(:small_business, :firstname => "UniqueTitleOne")
            FactoryGirl.create(:small_business, :firstname => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.small_businesses_admin_small_businesses_path
            page.should have_content("UniqueTitleOne")
            page.should have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          before do
            visit refinery.small_businesses_admin_small_businesses_path

            click_link "Add New Small Business"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Firstname", :with => "This is a test of the first string field"
              click_button "Save"

              page.should have_content("'This is a test of the first string field' was successfully added.")
              Refinery::SmallBusinesses::SmallBusiness.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("Firstname can't be blank")
              Refinery::SmallBusinesses::SmallBusiness.count.should == 0
            end
          end

          context "duplicate" do
            before { FactoryGirl.create(:small_business, :firstname => "UniqueTitle") }

            it "should fail" do
              visit refinery.small_businesses_admin_small_businesses_path

              click_link "Add New Small Business"

              fill_in "Firstname", :with => "UniqueTitle"
              click_button "Save"

              page.should have_content("There were problems")
              Refinery::SmallBusinesses::SmallBusiness.count.should == 1
            end
          end

        end

        describe "edit" do
          before { FactoryGirl.create(:small_business, :firstname => "A firstname") }

          it "should succeed" do
            visit refinery.small_businesses_admin_small_businesses_path

            within ".actions" do
              click_link "Edit this small business"
            end

            fill_in "Firstname", :with => "A different firstname"
            click_button "Save"

            page.should have_content("'A different firstname' was successfully updated.")
            page.should have_no_content("A firstname")
          end
        end

        describe "destroy" do
          before { FactoryGirl.create(:small_business, :firstname => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.small_businesses_admin_small_businesses_path

            click_link "Remove this small business forever"

            page.should have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::SmallBusinesses::SmallBusiness.count.should == 0
          end
        end

      end
    end
  end
end
