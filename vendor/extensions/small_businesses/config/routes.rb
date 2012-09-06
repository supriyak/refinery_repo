Refinery::Core::Engine.routes.append do

  # Frontend routes
  namespace :small_businesses do
    resources :small_businesses, :path => '', :only => [:index, :show]
  end

  # Admin routes
  namespace :small_businesses, :path => '' do
    namespace :admin, :path => 'refinery' do
      resources :small_businesses, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end

end
