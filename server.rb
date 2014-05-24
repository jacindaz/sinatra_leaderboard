require 'sinatra'
require 'rubygems'
require 'csv'
require 'pry'


#METHODS--------------------------------------------------------------
def load_csv(file_name)
  scores = []
  CSV.foreach(file_name, headers: true, header_converters: :symbol) do |score|
    scores << score.to_hash
  end
  scores
end

def return_keys(hash)
  return hash.keys
end

def teams(array_of_hashes)
  teams = []
  array_of_hashes.each do |game|
    home_team = game[:home_team]
    away_team = game[:away_team]
    if !teams.include?(home_team)
      teams << home_team
    elsif !teams.include?(away_team)
      teams << away_team
    end
  end
  #puts "#{teams}"
  return teams
end

#returns which team won based on the score
def won_or_lost(hash)
  if hash[:home_score] > hash[:away_score]
    return hash[:home_team]
  elsif hash[:away_score] > hash[:home_score]
    return hash[:away_team]
  end
end

def add_wonlost_data(array_of_hashes)
  team_wins_losses = []
  array_of_hashes.each do |game|
    if
    win_or_lost = {team_name: "", won: 0, lost: 0}
    winning_team = won_or_lost(game)
    win_or_lost[:team_name] = winning_team
    win_or_lost[:won] += 1
    team_wins_losses << win_or_lost
  end
  team_wins_losses
end

#ROUTES AND VIEWS------------------------------------------------------
get '/leaderboard' do
  @title = "Leaderboard"
  @leaderboard_array = load_csv("scores.csv")
  @keys = return_keys(@leaderboard_array[0])


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
