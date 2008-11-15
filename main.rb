require 'rubygems'
require 'sinatra'
require 'sequel'

configure do
  Sequel.connect('sqlite://claypigeon.db')
end

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')
require 'task'

helpers do
end

layout 'layout'

### Public


get '/' do #index
  tasks = Task.filter(:done => false)
  erb :index, :locals => { :tasks => tasks }
end

post '/tasks' do #create
  task = Task.new(:title => params[:task_input], :created_at => Time.now)
  task.save
  redirect '/'
end

post '/:task/done' do #destroy
  task = Task[params[:task]]
  task.destroy
  redirect '/'
end
