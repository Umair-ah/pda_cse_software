Rails.application.routes.draw do
  devise_for :admins
  root "guides#index"

  resources :guides, only: %i[index create destroy show] do
    collection do
      get :index_two
      post :update_two
    end
    get :show_two

  end




  resources :programs, only: %i[show]
  resources :projects, only: %i[show]
  resources :presentation, only: %i[show]
  resources :points, only: %i[show update] 
   
  



 

  resources :batches, only: %i[index show] do
    collection do
      post :import_students
      post :edit
      post :update
      post :create_two
      post :import_guides
    end
    get :show_two
  end

  resources :students do
    collection do
      post :edit_student
      post :update_student
    end
  end
  
end
