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
    p response.code
    if response.code == "200"
      render json: {}
    else 
      redirect_to '/'
    end
  end

  def login_page
    render 'user/login'
  end

  def register_page
    render 'user/register'
  end
end
