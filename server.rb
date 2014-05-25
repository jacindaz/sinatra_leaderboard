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

def extract_keys(array_of_hashes, *keys_to_extract)
  array_extracted_values = []
  array_of_hashes.each do |game|
    keys_to_extract.each do |key|
      if !array_extracted_values.include?(game[key])
        array_extracted_values << game[key]
      end
    end #end key array
  end #end array of hashes
  return array_extracted_values
end
#extract_keys([array of hashes of games], [:home_team, :away_team])

def create_hash_keys(array_of_keys, value)
  new_hash = {}
  array_of_keys.each do |key|
    new_hash[key] = value
  end
  return new_hash
end
#create_new_hash([:team, :wins, :losses])

def add_teams(array_of_teams, keys_array, key_to_update, default_key_value)
  array = []
  array_of_teams.each do |team|
    team_hash = create_hash_keys(keys_array, default_key_value)
    team = team.to_s.capitalize
    team_hash[key_to_update] = team
    array << team_hash
  end
  return array
end
#teams_wins_losses(["Patriots", "Colts"], [:team, :wins, :losses], 0)

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
def one_team(array_of_teams, team_name, team_key)
  array_of_teams.each do |team|
    if team[team_key] == team_name
      return team
    end
  end
end



#ROUTES AND VIEWS------------------------------------------------------
get '/leaderboard' do
  @title = "Leaderboard"
  @leaderboard_array = load_csv("scores.csv")
  @teams_array = extract_keys(@leaderboard_array, :home_team, :away_team)
  @teams_wins_losses = add_teams(@teams_array, [:team, :wins, :losses], :team, 0)

  @teams_update_wins_losses = add_wonlost_data(@teams_wins_losses, @leaderboard_array)

  erb :index
end


get '/' do
  redirect '/leaderboard'
end


get '/teams/:team_name' do
  @title = "Teams Page"
  @team_name = params[:team_name]
  @leaderboard_array = load_csv("scores.csv")
  @teams_array = extract_keys(@leaderboard_array, :home_team, :away_team)
  @teams_wins_losses = add_teams(@teams_array, [:team, :wins, :losses], :team, 0)
  @teams = add_wonlost_data(@teams_wins_losses, @leaderboard_array)

  @team_hash = one_team(@teams, @team_name, :team)

  erb :show
end
