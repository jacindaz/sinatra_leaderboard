require 'sinatra'
require 'rubygems'


@@leaderboard = [
  {
    home_team: "Patriots",
    away_team: "Broncos",
    home_score: 7,
    away_score: 3
  },
  {
    home_team: "Broncos",
    away_team: "Colts",
    home_score: 3,
    away_score: 0
  },
  {
    home_team: "Patriots",
    away_team: "Colts",
    home_score: 11,
    away_score: 7
  },
  {
    home_team: "Steelers",
    away_team: "Patriots",
    home_score: 7,
    away_score: 21
  }
]

#ROUTES AND VIEWS------------------------------------------------------
get '/leaderboard' do
  @title = "Leaderboard"
  @leaderboard_array = @@leaderboard
  erb :index
end

get '/' do
  redirect '/leaderboard'
end

get '/teams' do

  erb :show
end
