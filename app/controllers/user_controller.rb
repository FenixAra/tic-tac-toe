require 'net/http'
require_relative '../helpers/http'

class UserController < ApplicationController
  def register
    user = params
    mmobge_url = ENV['MMOBGE_URL'] || 'https://mmobge.herokuapp.com'
    uri = URI.parse(mmobge_url + '/v1/users')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/json'})
    request.body = {'user_name' => user['email'], 'email' => user['email'], 'password' => user['password1']}.to_json
    response = http.request(request)
    if response.code == "200"
      flash[:success] = 'Registration success'
      redirect_to '/'
    else 
      flash[:error] = 'Unable to register'
      redirect_to '/register'
    end
  end

  def logout
    reset_session
    redirect_to '/'
  end

  def login
    user = params
    mmobge_url = ENV['MMOBGE_URL'] || 'https://mmobge.herokuapp.com'
    uri = URI.parse(mmobge_url + '/v1/users/login')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/json'})
    request.body = {'user_name' => user['email'], 'password' => user['password']}.to_json
    response = http.request(request)
    if response.code == "200"
      user_info = JSON.parse(response.body)
      p user_info
      session[:user_id] = user_info['id']
      session[:email] = user['email']
      session[:first_name] = user_info['first_name']
      session[:last_name] = user_info['last_name']
      @board_id = session[:board_id]
      redirect_to '/dashboard'
    else 
      flash[:error] = 'Invalid username/password'
      redirect_to '/'
    end
  end

  def dashboard
    @user_id = session[:user_id]
    @email = session[:email]
    @first_name = session[:first_name]
    @last_name = session[:last_name]
    @board_id = session[:board_id]
    render :action => 'dashboard'
  end

  def edit
    user = params
    mmobge_url = ENV['MMOBGE_URL'] || 'https://mmobge.herokuapp.com'
    uri = URI.parse(mmobge_url + '/v1/users')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/json'})
    session[:first_name] = user['first_name']
    @board_id = session[:board_id]
    session[:last_name] = user['last_name']
    request.body = {'id' => session[:user_id], 'user_name' => session[:email], 'email' => session[:email], 'first_name' => user['first_name'], 'last_name' => user['last_name']}.to_json
    response = http.request(request)
    p response.code
    redirect_to '/dashboard'
  end

  def change_password
    password_details = params
    @board_id = session[:board_id]
    p params
    mmobge_url = ENV['MMOBGE_URL'] || 'https://mmobge.herokuapp.com'
    url = mmobge_url + '/v1/users/change/password'
    response = http_post(url, {'id' => session[:user_id], 'old_password' => password_details[:old_password], 'new_password' => password_details[:password1] } )
    if response.code == "200"
      flash[:success] = 'Change Password Success'
      redirect_to '/account'
    else
      flash[:error] = 'Unable to change password: ' + JSON.parse(response.body)["error"]
      redirect_to '/change/password'
    end
  end

  def login_page
    render 'user/login'
  end

  def register_page
    render 'user/register'
  end

  def change_password_page
    @user_id = session[:user_id]
    @email = session[:email]
    @board_id = session[:board_id]
    @first_name = session[:first_name]
    @last_name = session[:last_name]
    render 'user/change-password'
  end

  def account_page
    @user_id = session[:user_id]
    @email = session[:email]
    @board_id = session[:board_id]
    @first_name = session[:first_name]
    @last_name = session[:last_name]

    if !@user_id
      render 'user/login'
    else 
      render 'user/account'
    end
  end
end
