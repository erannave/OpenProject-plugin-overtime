OpenProject::Application.routes.draw do
  scope "overtime", as: "overtime" do
    # Admin routes
    namespace :overtime do
      resources :admin, only: [:index, :new, :create, :edit, :update, :destroy]

      # User routes
      get "my", to: "user_overtime#show", as: :my_overtime
      get "my/export", to: "user_overtime#export", as: :export_overtime
    end
  end
end
