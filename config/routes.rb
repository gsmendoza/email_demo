ActionController::Routing::Routes.draw do |map|
  map.connect '/generic_mailer/:table_name/:action/:id', :controller => 'generic_mailer'
end
