Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :admins
  root to: "empty#index"
  post '/formspark', to: 'people#formspark_webhook'
end
