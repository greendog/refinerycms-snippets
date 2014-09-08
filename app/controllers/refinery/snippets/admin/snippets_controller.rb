module Refinery
  module Snippets
    module Admin
      class SnippetsController < ::Refinery::AdminController

        crudify :'refinery/snippets/snippet',
                :xhr_paging => true


        private

        def snippet_params
          params.require(:snippet).permit(:id, :title, :body)
        end
      end
    end
  end
end
