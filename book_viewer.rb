require 'sinatra'
require 'tilt/erubis'

if development?
  require 'sinatra/reloader'
  require 'pry'
end

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
  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter
end

get '/search' do
  @query = params[:query]
  @results = []

  unless !@query || @query.empty?
    each_chapter do |title, number, chapter|
      if chapter.include?(@query)
        result = { title: title, number: number, paragraphs: [] }

        each_paragraph(chapter) do |paragraph, id|
          if paragraph.include?(@query)
            result[:paragraphs] << { text: paragraph, id: id }
          end
        end

        @results << result
      end
    end
  end

  erb :search
end

not_found do
  redirect '/'
end

helpers do
  def in_paragraphs(chapter)
    chapter.split("\n\n").map.with_index(1) do |line, index|
      "<p id=paragraph_#{index}>#{line}</p>"
    end.join
  end

  def highlight(text, term)
    text.gsub(term, "<strong>#{term}</strong>")
  end
end

def each_chapter
  @contents.each.with_index(1) do |title, number|
    chapter = File.read("data/chp#{number}.txt")
    yield title, number, chapter
  end
end

def each_paragraph(chapter)
  chapter.split("\n\n").each.with_index(1) do |paragraph, index|
      yield paragraph, "paragraph_#{index}"
  end
end
