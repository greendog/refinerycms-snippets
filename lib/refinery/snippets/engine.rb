module Refinery
  module Snippets
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::Snippets

      engine_name :refinery_snippets

      config.before_initialize do
        require 'extensions/page_extensions'
      end

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.name = "snippets"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.snippets_admin_snippets_path }
          plugin.pathname = root
          
        end

        Rails.application.config.assets.precompile += %w(
          page-snippet-picker.css
          page-snippet-picker.js
          part-snippets-select.js
        )
      end

      config.to_prepare do
        Refinery::PagePart.module_eval do
          has_many :snippet_page_parts, :dependent => :destroy, :class_name => "Refinery::Snippets::SnippetPagePart"
          has_many :snippets, :through => :snippet_page_parts, :class_name => "Refinery::Snippets::Snippet"
        end

        Refinery::Page.send :include, Extensions::Page

        Refinery::Pages::PagePartSectionPresenter.class_eval do
          def initialize(page_part)
            super()
            self.id = page_part.slug.to_sym if page_part.slug

            content = ""
            content += page_part.snippets.before.map{ |snippet| content_or_render_of(snippet) }.join
            content += page_part.body
            content += page_part.snippets.after.map{ |snippet| content_or_render_of(snippet) }.join

            self.fallback_html = content.html_safe
          end

          def content_or_render_of(snippet)
            snippet.template? ? render(:file => snippet.template_path) : snippet.body
          end
        end
      end


      config.after_initialize do
        ::Refinery::Pages::Tab.register do |tab|
          tab.name = "snippets"
          tab.partial = "/refinery/snippets/admin/pages/tabs/snippets"
        end

        Refinery.register_extension(Refinery::Snippets)
      end
    end
  end
end
