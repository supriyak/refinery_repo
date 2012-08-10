class EditIniquiryFields < ActiveRecord::Migration
  def up
   add_column :refinery_inquiries_inquiries,:first_name,:string
   add_column :refinery_inquiries_inquiries,:last_name,:string
   add_column :refinery_inquiries_inquiries,:subject,:text
  end

  def down
  end
end
