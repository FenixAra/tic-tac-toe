require_relative '../helpers/http'
require "securerandom"

class BoardsController < ApplicationController
  def boards_list
    if !session[:user_id] 
        return redirect_to '/'
    end
    mmobge_url = ENV['MMOBGE_URL'] || 'https://mmobge.herokuapp.com'
    url = mmobge_url + '/v1/boards?client_id=' + (ENV['CLIENT_ID'] || '28373e57-ffe2-4642-8d59-1f892464068c')

    response = http_get(url)
    response_json = JSON.parse(response.body)
    p response_json
    @user_id = session[:user_id]
    @email = session[:email]
    @first_name = session[:first_name]
    @last_name = session[:last_name]
    @boards = response_json["boards"]
    @count = response_json["count"]

    @boards = @boards.map{ |board| board["user_details"] ? (board["user_details"][0]["id"] != session[:user_id] ? board : nil) : nil }.compact
    
    render 'boards/boards'
  end

  def new_board_page
    if !session[:user_id] 
        return redirect_to '/'
    end
    mmobge_url = ENV['MMOBGE_URL'] || 'https://mmobge.herokuapp.com'
    board_url = mmobge_url + '/v1/boards'
    board_id = SecureRandom.uuid
    board_data = {
        'id' => board_id,
        'client_id' => (ENV['CLIENT_ID'] || '28373e57-ffe2-4642-8d59-1f892464068c'),
        'rows' => 3,
        'columns' => 3,
        'status' => 'OPEN',
        'squares' => [
            ["a1", "a2", "a3"],
            ["b1", "b2", "b3"],
            ["c1", "c2", "c3"]
        ]
    }
    response = http_post(board_url, board_data)
    if response.code == "200"
        session[:user_id]
        url = board_url + '/user'
        response = http_post(url, {'user_id' => session[:user_id], 'board_id' => board_id})
        Board.create({'id' => board_id, 'p1' => session[:user_id], 'status' => "OPEN", 'first_move' => session[:user_id], 'current_move' => session[:user_id]})
        session[:board_id] = board_id
        redirect_to '/boards/mine'
    else
        flash[:error] = 'Unable to create board'
        render json: {error: 'Unable to create board'}, :status => 500
    end
  end

  def my_board
    if !session[:user_id] 
        return redirect_to '/'
    end
    if !session[:board_id]
        return redirect_to '/boards/new'
    end
    @user_id = session[:user_id]
    @email = session[:email]
    @first_name = session[:first_name]
    @last_name = session[:last_name]
    @board_id = session[:board_id]

    mmobge_url = ENV['MMOBGE_URL'] || 'https://mmobge.herokuapp.com'
    board_url = mmobge_url + '/v1/boards/' + @board_id
    # board_url = mmobge_url + '/v1/boards/58cc5bff-7de4-4ebf-883f-4ea34b598bd9'

    response = http_get(board_url)
    @board_info = JSON.parse(response.body)

    @value_map = {}
    @board_info["squares"].map {|square| @value_map[square["name"]] = square["state"]}
    p @value_map

    p @board_info['board']['user_details']
    @board_data = Board.find(@board_id)
    p @board_data
    @p1 = @board_info['board']["user_details"].map{ |user| user["id"] == @board_data["p1"] ? user: nil}.compact[0]
    @p2 = @board_info['board']["user_details"].map{ |user| user["id"] == @board_data["p2"] ? user: nil}.compact[0]

    p @p1
    p @p2

    render 'boards/board'
  end

  def join_board
    session[:board_id] = params["id"]
    mmobge_url = ENV['MMOBGE_URL'] || 'https://mmobge.herokuapp.com'
    board_url = mmobge_url + '/v1/boards'
    
    board_data = Board.find(params["id"])
    response = http_post(board_url, {'id' => params["id"], 'status' => "INGAME" })
    p response
    url = board_url + '/user'
    response = http_post(url, {'user_id' => session[:user_id], 'board_id' => params["id"]})
    p response
    board_data.update({'p2' => session[:user_id], 'status' => "INGAME"})

    render json: {}
  end

  def set_square
    board_data = Board.find(session[:board_id])
    if board_data["current_move"] == session[:user_id]
        other_user = board_data["p1"] != session[:user_id] ? board_data["p1"] : board_data["p2"]
        value = 'X'
        if board_data["p1"] != session[:user_id]
            value = 'O'
        end
        mmobge_url = ENV['MMOBGE_URL'] || 'https://mmobge.herokuapp.com'
        url = mmobge_url + '/v1/boards/square/state'
        response = http_post(url, {'board_id' => session[:board_id], 'name' => params["id"], 'state' => {'value' => value}})
        p response
        board_data.update({'current_move' => other_user})
        render json: {}
    else
        render json: {}, :status => 400
    end
  end
end
