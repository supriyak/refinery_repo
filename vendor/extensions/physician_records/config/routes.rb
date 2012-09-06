Refinery::Core::Engine.routes.append do

  # Frontend routes
  namespace :physician_records do
    resources :physician_records, :path => '', :only => [:index, :show]
    resources :physician_records, :except => :show do
    	collection do
    	  post :update_positions
    	end
    end
  end

  # Admin routes
  namespace :physician_records, :path => '' do    
    namespace :admin, :path => 'refinery' do
      resources :physician_records, :path => '', :only => [:index, :show]
      
    end
  end

end
