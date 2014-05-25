require 'pry'

games = [
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


def create_hash_keys(array_of_keys)
  new_hash = {}
  array_of_keys.each do |key|
    new_hash[key] = nil
  end
  return new_hash
end
#create_new_hash([:team, :wins, :losses])

def teams_wins_losses(array_of_teams, keys_array)
  array = []
  array_of_teams.each do |team|
    team_hash = create_hash_keys(keys_array)
    team = team.capitalize
    team_hash[:team] = team
    array << team_hash
  end
  puts "Array: #{array}"
  return array
end
teams_wins_losses(["Patriots", "Colts"], [:team, :wins, :losses])


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
  #puts "#{teams}"
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
  puts "#{array_of_teams}"
  array_of_teams
end
#add_wonlost_data(teams, games)
