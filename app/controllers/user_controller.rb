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
    p response.code
    render json: {}
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

  def login_page
    render 'user/login'
  end

  def register_page
    render 'user/register'
  end
end
