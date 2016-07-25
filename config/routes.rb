Rails.application.routes.draw do

  scope '/v1' do
    scope '/users' do
      post '/register' => 'user#register'
      post '/login' => 'user#login'
      post '/edit' => 'user#edit'
      post '/edit' => 'user#edit'
      post '/change/password' => 'user#change_password'
      get '/logout' => 'user#logout'
    end
  end

  get '/' => 'user#login_page'
  get '/register' => 'user#register_page'
  get '/dashboard' => 'user#dashboard'
  get '/account' => 'user#account_page'
  get '/change/password' => 'user#change_password_page'
  get '/boards' => 'boards#boards_list'
  get '/boards/new' => 'boards#new_board_page'
  get '/boards/mine' => 'boards#my_board'
  get '/boards/:id/join' => 'boards#join_board'
  get '/boards/square/:id' => 'boards#set_square'
end
