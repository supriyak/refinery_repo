Refinery::Core::Engine.routes.append do
  namespace :physician_records do
    resources :physician_records, :path => '', :only => [:index, :show]
  end

  # Admin routes
  namespace :physician_records, :path => '' do
    namespace :admin, :path => 'refinery' do
      resources :physician_records, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end

end
