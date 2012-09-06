# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "PhysicianRecords" do
    describe "Admin" do
      describe "physician_records" do
        login_refinery_user

        describe "physician_records list" do
          before do
            FactoryGirl.create(:physician_record, :firstname => "UniqueTitleOne")
            FactoryGirl.create(:physician_record, :firstname => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.physician_records_admin_physician_records_path
            page.should have_content("UniqueTitleOne")
            page.should have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          before do
            visit refinery.physician_records_admin_physician_records_path

            click_link "Add New Physician Record"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Firstname", :with => "This is a test of the first string field"
              click_button "Save"

              page.should have_content("'This is a test of the first string field' was successfully added.")
              Refinery::PhysicianRecords::PhysicianRecord.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("Firstname can't be blank")
              Refinery::PhysicianRecords::PhysicianRecord.count.should == 0
            end
          end

          context "duplicate" do
            before { FactoryGirl.create(:physician_record, :firstname => "UniqueTitle") }

            it "should fail" do
              visit refinery.physician_records_admin_physician_records_path

              click_link "Add New Physician Record"

              fill_in "Firstname", :with => "UniqueTitle"
              click_button "Save"

              page.should have_content("There were problems")
              Refinery::PhysicianRecords::PhysicianRecord.count.should == 1
            end
          end

        end

        describe "edit" do
          before { FactoryGirl.create(:physician_record, :firstname => "A firstname") }

          it "should succeed" do
            visit refinery.physician_records_admin_physician_records_path

            within ".actions" do
              click_link "Edit this physician record"
            end

            fill_in "Firstname", :with => "A different firstname"
            click_button "Save"

            page.should have_content("'A different firstname' was successfully updated.")
            page.should have_no_content("A firstname")
          end
        end

        describe "destroy" do
          before { FactoryGirl.create(:physician_record, :firstname => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.physician_records_admin_physician_records_path

            click_link "Remove this physician record forever"

            page.should have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::PhysicianRecords::PhysicianRecord.count.should == 0
          end
        end

      end
    end
  end
end
