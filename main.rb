load 'ar.rb'

class BatterUp

  def initialize(at_bat_min)
    @@players = Player.find_players_by_at_bat(at_bat_min)
  end

  def batting_averages(at_bat_min, from, to)
    # most improved batting average
    results = []
    Player.find_players_by_at_bat(at_bat_min).each do |player|
      results << "Name: #{player.first_name} #{player.last_name}, Batting Avg: #{player.batting_average(from, to)}"
    end
    results
  end

  def slugging_percentages(team, year)
    results = []
    Player.find_players_by_team_and_year(team, year).each do |player|
      results << "Name: #{player.first_name} #{player.last_name}, Slugging Percentage: #{player.slugging_percentage(year, year)}"
    end
    results
  end

  def triple_crown_winner(league, year)
    league_players = @@players.select { |player| player.played_in_league?(league, year) }
    player_id = Player.highest_batting_average(league_players, year).player_id

    name =
      if player_id == Player.most_home_runs(league_players, year).player_id and player_id == Player.most_rbi(league_players, year).player_id
        player = Player.find_by_player_id(player_id)
        "#{player.first_name} #{player.last_name}"
      else
        '(No winner)'
      end

    "#{league} Triple Crown Winner for #{year}: #{name}"
  end
end

app = BatterUp.new(400)

p 'Batting averages'
app.batting_averages(200, 2009, 2010).each { |ba| p ba }

p 'Slugging percentages'
app.slugging_percentages('OAK', 2007).each { |sp| p sp }

p app.triple_crown_winner('AL', 2011)
p app.triple_crown_winner('AL', 2012)
p app.triple_crown_winner('NL', 2011)
p app.triple_crown_winner('NL', 2012)
