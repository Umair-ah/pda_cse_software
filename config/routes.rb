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
  
  resources :projects, only: %i[show] do
    collection do
      get :fetch_by_program
    end
  end

  resources :presentation, only: %i[show]
  resources :points, only: %i[show update] 
   
  



 

  resources :batches, only: %i[index show] do
    collection do
      post :import_students
      post :edit
      post :update
      post :create_two
      get :index_two
      get :assign_guides_manually
      post :assign_guides_manually_post
      get :change_teammate
      post :change_teammate_post
      
      # import students via excel
      post :preview_students
      get :preview_students_in_html
      post :confirm_students
      post :cancel_students
      
      # import guides via excel
      post :preview_guides
      get :preview_guides_in_html
      post :confirm_guides
      post :cancel_guides


    end
    get :show_two
  end

  resources :students, only: :show do
    collection do
      post :edit_student
      post :update_student
      post :update_guide
    end
  end
  
end
