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

def winning_team(hash, team1, team2, team1_score, team2_score)
  if hash[team1_score].to_i > hash[team2_score].to_i
    return hash[team1]
  elsif hash[team2_score].to_i > hash[team1_score].to_i
    return hash[team2]
  end
end

def losing_team(hash, team1, team2, team1_score, team2_score)
  if hash[team1_score].to_i < hash[team2_score].to_i
    return hash[team1]
  elsif hash[team2_score].to_i < hash[team1_score].to_i
    return hash[team2]
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

def teams_wins_losses(array_of_teams)
  array = []
  array_of_teams.each do |team|
    team = team.capitalize
    team_hash = {team: "#{team}", wins: 0, losses: 0}
    array << team_hash
  end
  return array
end

def add_wonlost_data(array_of_teams, array_of_games)
  array_of_games.each do |game|
    winning_team = winning_team(game, :home_team, :away_team, :home_score, :away_score)
    losing_team = losing_team(game, :home_team, :away_team, :home_score, :away_score)
    index = array_of_teams.length
    array_index = index - 1
    index.times do
      case array_of_teams[array_index][:team]
      when winning_team
        array_of_teams[array_index][:wins] += 1
      when losing_team
        array_of_teams[array_index][:losses] += 1
      end
      array_index -= 1
    end #end times loop
  end
  array_of_teams = array_of_teams.sort_by { |team| team[:losses].to_i}
  array_of_teams
end

#return a specific team's hash
def one_team(array_of_teams, team_name)
  array_of_teams.each do |team|
    if team[:team] == team_name
      return team
    end
  end
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

get '/teams/:team_name' do
  @title = "Teams Page"
  @team_name = params[:team_name]
  @leaderboard_array = load_csv("scores.csv")
  @teams = teams(@leaderboard_array)
  @teams_wins_losses = teams_wins_losses(@teams)
  @teams = add_wonlost_data(@teams_wins_losses, @leaderboard_array)

  @team_hash = one_team(@teams, @team_name)

  erb :show
end
