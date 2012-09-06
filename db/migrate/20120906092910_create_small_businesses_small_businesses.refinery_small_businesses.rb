# This migration comes from refinery_small_businesses (originally 1)
class CreateSmallBusinessesSmallBusinesses < ActiveRecord::Migration

  def up
    create_table :refinery_small_businesses do |t|
      t.string :firstname
      t.string :lastname
      t.string :company
      t.string :title
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.string :email
      t.integer :employees
      t.integer :position

      t.timestamps
    end

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-small_businesses"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/small_businesses/small_businesses"})
    end

    drop_table :refinery_small_businesses

  end

end
