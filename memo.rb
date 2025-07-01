# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

set :environment, :production

def file_open
  File.open('memos.json') do |file|
    @memos = JSON.parse(file.read, symbolize_names: true)
  end
end

def set_current_memo
  @current_memo = @memos.find do |memo|
    memo[:id] == params[:id].to_i
  end
end

def write_json(id, title, memo_content)
  title = title.empty? ? 'No-title' : title
  @memos << { id: id.to_i, title: title, memo_content: memo_content }
  save_memos_to_file
end

def find_memo_index(id)
  @memos.index { |value| value[:id] == id.to_i }
end

def save_memos_to_file
  File.open('memos.json', 'w') do |file|
    JSON.dump(@memos, file)
  end
end

before do
  file_open
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  erb :index
end

get '/memos/new' do
  erb :new_memo
end

get '/memos/:id' do
  set_current_memo
  erb :show_memo
end

post '/memos' do
  hash_size = @memos.size
  id = hash_size.zero? ? 1 : @memos.map { |value| value[:id].to_i }.max + 1
  write_json(id, params[:memo_title], params[:memo_content])
  erb :new_memo
  redirect '/'
end

delete '/memos/:id' do
  delete_index = find_memo_index(params[:id])
  @memos.delete_at delete_index if delete_index
  save_memos_to_file
  redirect '/'
end

get '/memos/:id/edit' do
  set_current_memo
  erb :edit_memo
end

patch '/memos/:id' do
  update_index = find_memo_index(params[:id])
  if update_index
    @memos[update_index][:title] = params[:title]
    @memos[update_index][:memo_content] = params[:memo_content]
    save_memos_to_file
    redirect '/'
  end
end
