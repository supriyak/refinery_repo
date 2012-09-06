Refinery::Application.routes.draw do

  # This line mounts Refinery's routes at the root of your application.
  # This means, any requests to the root URL of your application will go to Refinery::PagesController#home.
  # If you would like to change where this extension is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Refinery relies on it being the default of "refinery"

  match '/physicians_new',  :controller => 'physicians', :action => 'create', :method => "POST"
  match '/small_businesses_new',  :controller => 'small_businesses', :action => 'create', :method => "POST"
  match '/discounts',  :controller => 'discounts', :action => 'fulfill_index'
  match '/fulfillment_print/:id'=> "coupons#fulfillment_print", :as => :coupon_fulfillment_print
  match '/fulfillment_option/:id'=> "coupons#fulfillment_option", :as => :coupon_fulfillment_option
  match '/discounts/search', :controller => 'discounts', :action => 'search'
  match '/discounts/simple_search', :controller => 'discounts', :action => 'simple_search'
  match '/discounts/thanks_submit', :controller => 'discounts', :action => 'thanks_submit'
  match '/fulfillment/:id'=> "coupons#fulfillment", :as => :coupon_fulfillment
  match '/fulfillment_print/:id'=> "coupons#fulfillment_print", :as => :coupon_fulfillment_print
  match '/fulfillment_option/:id'=> "coupons#fulfillment_option", :as => :coupon_fulfillment_option
  match '/printable_discount/:id' => "coupons#prescription_discount", :as => :coupon_printable_discount
  match '/printable_discount_1/:id' => "coupons#prescription_discount_1", :as => :coupon_printable_discount_1
  match '/printable_discount_2/:id' => "coupons#prescription_discount_2", :as => :coupon_printable_discount_2
  match '/printable_discount_3/:id' => "coupons#prescription_discount_3", :as => :coupon_printable_discount_3
  match '/printable_discount_4/:id' => "coupons#prescription_discount_4", :as => :coupon_printable_discount_4
  match '/printable_discount_5/:id' => "coupons#prescription_discount_5", :as => :coupon_printable_discount_5
  match '/printable_discount_6/:id' => "coupons#prescription_discount_6", :as => :coupon_printable_discount_6
  match '/printable_discount', :controller => 'discounts', :action => 'index'  
  match '/PRESCRIPTION_DISCOUNT', :controller => 'discounts', :action => 'index'
  match '/PRESCRIPTION_DISCOUNT/:coupon', :controller => 'coupons', :action => 'prescription_discount'
  scope "print" do 
      match '/home', :controller => 'dashboards', :action => 'print_home', :as => :print_home
      match '/printable_discount', :controller => 'discounts', :action => 'print_index', :as => :print_discounts
      match '/discounts', :controller => 'discounts', :action => 'print_index', :as => :print_discounts
      match '/printable_discount/:id' => "coupons#print_prescription_discount", :as => :print_coupon_printable_discount
  end
  scope "email" do
      match '/home', :controller => 'dashboards', :action => 'email_home', :as => :email_home
      match '/printable_discount', :controller => 'discounts', :action => 'email_index', :as => :email_discounts
      match '/discounts', :controller => 'discounts', :action => 'email_index', :as => :email_discounts
      match '/printable_discount/:id' => "coupons#email_prescription_discount", :as => :email_coupon_printable_discount
      match '/send_coupon', :controller => 'coupons', :action => 'send_coupon_email', :as => :send_coupon_email
      match '/sign-up', :controller => 'transferred_data', :action => 'new', :as => 'email_signup'
      match '/new-sign-up', :controller => 'transferred_data', :action => 'new', :as => 'new_email_signup'
      match '/helprx-sign-up', :controller => 'transferred_data', :action => 'new_lightbox', :as => 'email_helprx_signup'
      match '/transferred_data/email_thanks_submit', :controller => 'transferred_data', :action => 'thanks_submit', :as => 'email_thanks_submit'
    end
    
    scope "sms" do 
      match '/printable_discount', :controller => 'discounts', :action => 'sms_index', :as => :sms_discounts
      match '/discounts', :controller => 'discounts', :action => 'sms_index', :as => :sms_discounts
      match '/printable_discount/:id' => "coupons#sms_prescription_discount", :as => :sms_coupon_printable_discount
      match '/send_coupon', :controller => 'coupons', :action => 'send_coupon_sms', :as => :send_coupon_sms
      match '/helprx-sign-up', :controller => 'transferred_data', :action => 'new_lightbox', :as => 'sms_helprx_signup'
      match '/transferred_data/sms_thanks_submit', :controller => 'transferred_data', :action => 'thanks_submit', :as => 'sms_thanks_submit'
  end
  scope "fulfill" do
    match '/printable_discount', :controller => 'discounts', :action => 'fulfill_index', :as => :fulfill_discounts
    match '/discounts', :controller => 'discounts', :action => 'fulfill_index', :as => :fulfill_discounts
  end
  mount Refinery::Core::Engine, :at => '/'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
