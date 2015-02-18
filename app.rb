require 'pry'
require 'sinatra'
require 'better_errors'
require 'sinatra/reloader'
require 'pg'

require './models/squad'
require './models/student'

set :conn, PG.connect( dbname: 'weekendlab' )

before do
  @conn = settings.conn
  Squad.conn = @conn
  Student.conn = @conn
end

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end

# SQUAD ROUTES

get '/' do
  redirect '/squads'
end
#--------LISTS ALL THE SQUADS
get '/squads' do
  @squads = Squad.all
  erb :'squads/index'
end

get '/squads/new' do
  erb :'squads/add'
end
#--------SHOWS ONE SQUAD
get '/squads/:id' do
  @squad = Squad.find params[:id].to_i 

  erb :'squads/show'
end
#--------GET EDIT SQUAD
get '/squads/:id/edit' do
  @squad = Squad.find params[:id].to_i
  erb :'squads/edit'
end
#--------CREATE SQUAD
post '/squads' do
  Squad.create params
  redirect '/squads'
end
#--------POST EDIT SQUAD
put '/squads/:id' do
  s = Squad.find(params[:id].to_i)
  s.name = params[:name]
  s.mascot = params[:mascot]
  s.save
  redirect '/squads'
end
#--------DELETE SQUAD
delete '/squads/:id' do
  Squad.find(params[:id].to_i).destroy
  redirect '/squads'
end

# STUDENT ROUTES

get '/squads/:squad_id/students' do
  @students = Squad.find(params[:squad_id].to_i).students
  erb :'students/index'
end

get '/squads/:squad_id/students/new' do
  @squad_id = params[:squad_id].to_i
  erb :'students/add'
end
#--------SHOW STUDENT -- DONE
get '/squads/:squad_id/students/:student_id' do
  @student = Student.find params[:student_id].to_i
  erb :'students/show'
end
#--------EDIT STUDENT -- DONE
get '/squads/:squad_id/students/:student_id/edit' do
  @student = Student.find params[:student_id].to_i
  erb :'students/edit'
end
#--------CREATE STUDENT
post '/squads/:squad_id/students' do
  Student.create params
  redirect "/squads/#{params[:squad_id].to_i}"
end
#--------POST EDIT STUDENT
put '/squads/:squad_id/students/:student_id' do
  student = Student.find params[:student_id].to_i
  student.name = params[:name]
  student.age = params[:age]
  student.spirit_animal = params[:spirit_animal]
  student.save
  redirect "/squads/#{params[:squad_id].to_i}"
end
#--------DELETE STUDENT
delete '/squads/:squad_id/students/:student_id' do
  Student.find(params[:student_id].to_i).destroy
  redirect "/squads/#{params[:squad_id].to_i}"
end
