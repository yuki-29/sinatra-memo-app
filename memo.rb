# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'pg'

set :environment, :production

def load_memos
  result = settings.db.exec('SELECT * FROM memos ORDER BY id')
  @memos = result.map { |value| value.transform_keys!(&:to_sym) }
end

def find_memo(id)
  selected_memo = settings.db.exec_params('SELECT * FROM memos WHERE id = $1', [id])
  @current_memo = selected_memo[0].transform_keys!(&:to_sym)
end

def save_memo(title, content)
  title = title.empty? ? 'No-title' : title
  settings.db.exec_params('INSERT INTO memos(title, content) VALUES($1, $2)', [title, content])
end

def update_memo(id, title, content)
  title = title.empty? ? 'No-title' : title
  settings.db.exec_params('UPDATE memos SET title = $2, content = $3 WHERE id = $1', [id, title, content])
end

def delete_memo(id)
  settings.db.exec_params('DELETE FROM memos WHERE id = $1', [id])
end

configure do
  set :db, PG::Connection.new(dbname: 'memos_app')
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  load_memos
  erb :index
end

get '/memos/new' do
  erb :new_memo
end

get '/memos/:id' do
  find_memo(params[:id])
  erb :show_memo
end

post '/memos' do
  save_memo(params[:memo_title], params[:memo_content])
  redirect '/'
end

delete '/memos/:id' do
  delete_memo(params[:id])
  redirect '/'
end

get '/memos/:id/edit' do
  find_memo(params[:id])
  erb :edit_memo
end

patch '/memos/:id' do
  update_memo(params[:id], params[:title], params[:memo_content])
  redirect '/'
end
