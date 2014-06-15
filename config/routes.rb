Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :build_indicators, only: [:index, :show] do
        member do
          get "status"
        end
      end
    end
  end
end
