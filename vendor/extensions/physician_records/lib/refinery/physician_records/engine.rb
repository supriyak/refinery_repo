module Refinery
  module PhysicianRecords
    class Engine < Rails::Engine
      include Refinery::Engine
      isolate_namespace Refinery::PhysicianRecords

      engine_name :refinery_physician_records

      initializer "register refinerycms_physician_records plugin" do
        Refinery::Plugin.register do |plugin|
          plugin.name = "physician_records"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.physician_records_admin_physician_records_path }
          plugin.pathname = root
          plugin.activity = {
            :class_name => :'refinery/physician_records/physician_record',
            :title => 'firstname'
          }
          
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::PhysicianRecords)
      end
    end
  end
end
