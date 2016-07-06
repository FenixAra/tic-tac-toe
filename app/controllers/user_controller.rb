require 'net/http'

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
      session[:user_id] = JSON.parse(response.body)['id']
      session[:email] = user['email']
      redirect_to '/dashboard'
    else 
      flash[:error] = 'Invalid username/password'
      redirect_to '/'
    end
  end

  def dashboard
    @user_id = session[:user_id]
    @email = session[:email]
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
    request.body = {'id' => session[:user_id], 'user_name' => session[:email], 'email' => session[:email], 'first_name' => user['first_name'], 'last_name' => user['last_name']}.to_json
    response = http.request(request)
    p response.code
    redirect_to '/dashboard'
  end

  def login_page
    render 'user/login'
  end

  def register_page
    render 'user/register'
  end

  def account_page
    @user_id = session[:user_id]
    @email = session[:email]
    if !@user_id
      render 'user/login'
    else 
      render 'user/account'
    end
  end
end
