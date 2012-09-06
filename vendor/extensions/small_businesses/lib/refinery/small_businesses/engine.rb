module Refinery
  module SmallBusinesses
    class Engine < Rails::Engine
      include Refinery::Engine
      isolate_namespace Refinery::SmallBusinesses

      engine_name :refinery_small_businesses

      initializer "register refinerycms_small_businesses plugin" do
        Refinery::Plugin.register do |plugin|
          plugin.name = "small_businesses"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.small_businesses_admin_small_businesses_path }
          plugin.pathname = root
          plugin.activity = {
            :class_name => :'refinery/small_businesses/small_business',
            :title => 'firstname'
          }
          
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::SmallBusinesses)
      end
    end
  end
end
