require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'pry'

get '/' do
  @title = 'The Adventures of Sherlock Holmes'
  @contents = File.readlines('data/toc.txt')
  erb :home
end

get '/chapters/:number' do
  @contents = File.readlines('data/toc.txt')
  number = params[:number].to_i
  @title = "Chapter #{number}: #{@contents[number - 1]}"
  @chapter = File.read("data/chp#{number}.txt").split("\n")

  erb :chapter
end
