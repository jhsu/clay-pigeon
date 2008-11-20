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
  task = Task.new(:created_at => Time.now)
  task.input_text = params[:task_input].to_s
  task.save
  redirect '/'
end

get '/:task/delay' do #delay
  if task = Task[params[:task]]
    task.delay
  end
  redirect '/'
end

get '/:task/done' do #destroy temporary solution
  if task = Task[params[:task]]
    task.destroy
  end
  redirect '/'
end

post '/:task/done' do #destroy
  task = Task[params[:task]]
  task.destroy
  redirect '/'
end
