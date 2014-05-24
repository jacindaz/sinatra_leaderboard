require 'sinatra'
require 'rubygems'
require 'csv'


#METHODS--------------------------------------------------------------
def load_csv(file_name)
  scores = []
  CSV.foreach(file_name, headers: true, header_converters: :symbol) do |score|
    scores << score.to_hash
  end
  scores
end


#ROUTES AND VIEWS------------------------------------------------------
get '/leaderboard' do
  @title = "Leaderboard"
  @leaderboard_array = load_csv("scores.csv")
  erb :index
end

get '/' do
  redirect '/leaderboard'
end

get '/teams' do
  @title = "Teams Page"
  @leaderboard_array = load_csv("scores.csv")
  erb :show
end
