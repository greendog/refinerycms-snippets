require 'refinerycms-core'
require 'refinerycms-pages'

module Refinery
  autoload :SnippetsGenerator, 'generators/refinery/snippets_generator'

  module Snippets
    require 'refinery/snippets/engine'

    autoload :Tab, 'refinery/snippets/tabs'

    class << self
      attr_writer :root
      attr_writer :tabs

      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end

      def tabs
        @tabs ||= []
      end

      def factory_paths
        @factory_paths ||= [ root.join('spec', 'factories').to_s ]
      end
    end
  end
end
