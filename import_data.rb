file_path = "data/Master-small.csv"

CSV.foreach(file_path, :headers => true) do |row|
  player = Player.new
  player.player_id = row[0]
  player.birth_year = row[1]
  player.first_name = row[2]
  player.last_name = row[3]
  player.save
end

file_path = "data/Batting-07-12.csv"

CSV.foreach(file_path, :headers => true) do |row|
  statistic = Statistic.new
  statistic.player_id = row[0]
  statistic.year_id = row[1]
  statistic.league = row[2]
  statistic.team_id = row[3]
  statistic.games = row[4]
  statistic.at_bat = row[5]
  statistic.runs = row[6]
  statistic.hits = row[7]
  statistic.doubles = row[8]
  statistic.triples = row[9]
  statistic.home_runs = row[10]
  statistic.runs_batted_in = row[11]
  statistic.stolen_bases = row[12]
  statistic.caught_stealing = row[13]
  statistic.save
end
