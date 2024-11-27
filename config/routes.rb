Rails.application.routes.draw do
  root "batches#index"

  resources :guides, only: %i[index create destroy show]
  resources :programs, only: %i[show]
  resources :projects, only: %i[show]


 

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
