Rails.application.routes.draw do
  root "batches#index"

  #resources :students
 

  resources :batches, only: %i[create index show] do
    collection do
      post :import_students
      post :edit
      post :update
    end
  end
  
end
