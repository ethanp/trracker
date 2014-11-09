Rails.application.routes.draw do

  root to: redirect('static/landing'), as: :homepage

  devise_for :users
  resources :users

  get 'static/landing', as: :home
  get 'static/about', as: :about
  get 'static/help'

  shallow do
    resources :categories do
      resources :tasks, except: [:index] do
        resources :subtasks
        resources :intervals
      end
    end
  end

  # this is a simpler url than the default given by the nested routes
  get   '/tasks' => 'tasks#index', as: :list_tasks

  # accept intervals via ajax
  # the record/stop button
  post  '/tasks/:task_id/intervals-ajax' => 'intervals#create_from_ajax'

  # PATCH is for the buttons that edit a resource
  patch '/tasks/:id/complete' => 'tasks#complete', as: :complete_task
  patch '/tasks/:id/turn_in' => 'tasks#turn_in', as: :turn_in_task
  patch '/subtasks/:id/complete' => 'subtasks#complete', as: :complete_subtask

  # special 'today' table
  get 'today' => 'tasks#worked_on_today', as: :tasks_today

  # heatmap data via ajax (for tasks#show) [comes in from d3 path "#{path_prefix}/heatmap.json"]
  get '/tasks/:task_id/heatmap' => 'tasks#show_heatmap_data', as: :show_task_heatmap_data

  # category-graph data via ajax (for homepage)
  get '/categories/:category_id/time_per_task_per_day' => 'categories#time_per_task_per_day',
      as: :time_per_day

  # TODO this must be for something I never finished
  get '/static/task_data.json' => 'categories#stacked_chart_data', as: :stacked_chart_data

  # The priority is based upon order of creation: first created -> highest priority.
end
