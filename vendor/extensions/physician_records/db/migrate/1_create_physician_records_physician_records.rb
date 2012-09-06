class CreatePhysicianRecordsPhysicianRecords < ActiveRecord::Migration

  def up
    create_table :refinery_physician_records do |t|
      t.string :firstname
      t.string :lastname
      t.string :practicename
      t.string :doctorname
      t.string :office_manager
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.string :fax
      t.integer :npi_number
      t.string :email
      t.integer :position

      t.timestamps
    end

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-physician_records"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/physician_records/physician_records"})
    end

    drop_table :refinery_physician_records

  end

end
