Rails.application.routes.draw do
  root "batches#index"

  #resources :students
 

  resources :batches, only: %i[create index show] do
    collection do
      post :import_students
      post :edit
      post :update
      post :import_guides
    end
    get :show_two
  end
  
end
