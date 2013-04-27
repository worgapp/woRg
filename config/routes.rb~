WoRg::Application.routes.draw do
	
	root :to => "session#index"

	match "/login", :controller => "session", :action => "login"
	match "/logout", :controller => "session", :action => "logout"
	match "/home", :controller => "session", :action => "home"
	match "/first", :controller => "session", :action => "first_login"
	match "/f_pwd", :controller => "session", :action => "f_pwd"
	match "/settings", :controller => "session", :action => "settings"
	match "/info_birthdate", :controller => "session", :action => "info_birthdate"

	match "/wardrobe", :controller => "wardrobe", :action => "wardrobe"
	match "/outfit", :controller => "wardrobe", :action => "outfit"
	match "/results", :controller => "wardrobe", :action => "results"
	match "/results_vis", :controller => "wardrobe", :action => "results_vis"
	match "/dress", :controller => "wardrobe", :action => "dress"
	match "/search", :controller => "wardrobe", :action => "search"

	GET "/imgs/"

	resources :session
	resources :partials
end
