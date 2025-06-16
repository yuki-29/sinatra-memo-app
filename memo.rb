# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

set :environment, :production

def file_open
  File.open('data.json') do |file|
    @memo_data = JSON.parse(file.read)
  end
end

def memo_data_output
  @memo_data.each do |key, value|
    next unless params[:id] == key

    @id = key
    @title = value['title']
    @memo_content = value['memo_content']
  end
end

def write_json(id, title, memo_content)
  title = title.empty? ? 'No-title' : title
  File.open('data.json', 'w') do |file|
    @memo_data[id] = { 'title' => title, 'memo_content' => memo_content }
    JSON.dump(@memo_data, file)
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

get '/show/:id' do
  memo_data_output
  erb :show_memo
end

get '/new' do
  erb :new_memo
end

post '/save' do
  hash_size = @memo_data.size
  memo_list_ids = []

  if hash_size.zero?
    id = 1
    write_json(id, params[:memo_title], params[:memo_content])
  else
    @memo_data.each do |i|
      memo_list_ids << i[0].to_i
    end
    write_json(memo_list_ids.max + 1, params[:memo_title], params[:memo_content])
  end

  erb :new_memo
  redirect '/'
end

delete '/del/:id' do
  File.open('data.json', 'w') do |file|
    @memo_data.delete(params[:id])
    JSON.dump(@memo_data, file)
  end
  redirect '/'
end

get '/edit/:id' do
  memo_data_output
  erb :edit_memo
end

patch '/save/:id' do
  @memo_data.each do |key|
    next unless params[:id] == key[0]

    write_json(params[:id], params[:memo_title], params[:memo_content])
    redirect '/'
    break
  end
end
