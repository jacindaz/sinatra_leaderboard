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

teams([{:home_team=>"Patriots", :away_team=>"Broncos", :home_score=>"7", :away_score=>"3"}, {:home_team=>"Broncos", :away_team=>"Colts", :home_score=>"3", :away_score=>"0"}, {:home_team=>"Patriots", :away_team=>"Colts", :home_score=>"11", :away_score=>"7"}, {:home_team=>"Steelers", :away_team=>"Patriots", :home_score=>"7", :away_score=>"21"}])
