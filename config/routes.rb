Refinery::Core::Engine.routes.draw do
  # Admin routes
  namespace :snippets, :path => '' do
    namespace :admin, :path => Refinery::Core.backend_route do
      resources :snippets, :except => :show

      resources :snippets_page_parts do
        member do
          get 'add'
          get 'remove'
        end
      end

    end
  end

end
