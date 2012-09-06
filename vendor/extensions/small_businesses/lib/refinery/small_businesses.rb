require 'refinerycms-core'

module Refinery
  autoload :SmallBusinessesGenerator, 'generators/refinery/small_businesses_generator'

  module SmallBusinesses
    require 'refinery/small_businesses/engine'

    class << self
      attr_writer :root

      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end

      def factory_paths
        @factory_paths ||= [ root.join('spec', 'factories').to_s ]
      end
    end
  end
end
