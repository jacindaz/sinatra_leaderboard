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

def winning_team(hash)
  if hash[:home_score].to_i > hash[:away_score].to_i
    return hash[:home_team]
  elsif hash[:away_score].to_i > hash[:home_score].to_i
    return hash[:away_team]
  end
end

def losing_team(hash)
  if hash[:home_score].to_i < hash[:away_score].to_i
    return hash[:home_team]
  elsif hash[:away_score].to_i < hash[:home_score].to_i
    return hash[:away_team]
  end
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
  return teams
end


def add_wonlost_data(array_of_teams, array_of_games)
  array_of_games.each do |game|
    winning_team = winning_team(game)
    losing_team = losing_team(game)
    index = array_of_teams.length
    array_index = index - 1
    index.times do
      case array_of_teams[array_index][:team_name]
      when winning_team
        array_of_teams[array_index][:won] += 1
      when losing_team
        array_of_teams[array_index][:lost] += 1
      end
      array_index -= 1
    end #end times loop
  end
  array_of_teams
end

#ROUTES AND VIEWS------------------------------------------------------
get '/leaderboard' do
  @title = "Leaderboard"
  @leaderboard_array = load_csv("scores.csv")
  @teams = teams(@leaderboard_array)
  @teams_wins_losses = teams_wins_losses(@teams)

  @teams_updated = add_wonlost_data(@teams_wins_losses, @leaderboard_array)


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
