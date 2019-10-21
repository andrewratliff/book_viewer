require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require 'pry'

get "/" do
  @title = 'The Adventures of Sherlock Holmes'
  @contents = File.readlines('data/toc.txt')
  erb :home
end

get "/chapters/:chapter_number" do
  chapter_number = params[:chapter_number]
  @title = "Chapter #{chapter_number}"
  @contents = File.readlines('data/toc.txt')
  @chapter = File.read("data/chp#{chapter_number}.txt").split("\n")

  erb :chapter
end
