require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'pry'

before do
  @contents = File.readlines('data/toc.txt')
end

get '/' do
  @title = 'The Adventures of Sherlock Holmes'
  erb :home
end

get '/chapters/:number' do
  number = params[:number].to_i
  @title = "Chapter #{number}: #{@contents[number - 1]}"
  @chapter = File.read("data/chp#{number}.txt").split("\n")

  erb :chapter
end
