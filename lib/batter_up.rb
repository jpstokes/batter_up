# file: batter_up.rb
class BatterUp
  TRIPLE_CROWN_AT_BAT_MIN = 400

  def batting_averages(at_bat_min, from, to)
    # most improved batting average
    results = []
    Player
      .find_players_by_at_bat_and_period(at_bat_min, from, to).each do |player|
      results << "Name: #{player.first_name} #{player.last_name}, " \
        "Batting Avg: #{player.batting_average(from, to)}"
    end
    results
  end

  def slugging_percentages(team, year)
    results = []
    Player.find_players_by_team_and_year(team, year).each do |player|
      results << "Name: #{player.first_name} #{player.last_name}, " \
        "Slugging Percentage: #{player.slugging_percentage(year, year)}"
    end
    results
  end

  def triple_crown_winner(league, year)
    @players ||= Player.find_players_by_at_bat_and_period(TRIPLE_CROWN_AT_BAT_MIN, year, year)

    league_players = @players.select { |player| player.played_in_league?(league, year) }
    batting_avg_player_id = Player.highest_batting_average(league_players, year).try(:player_id)
    home_run_player_id = Player.most_home_runs(league_players, year).try(:player_id)
    rbi_player_id = Player.most_rbi(league_players, year).try(:player_id)

    name =
      if !batting_avg_player_id.nil? && batting_avg_player_id == home_run_player_id &&
        batting_avg_player_id == rbi_player_id

        player = Player.find_by_player_id(batting_avg_player_id)
        "#{player.first_name} #{player.last_name}"
      else
        '(No winner)'
      end

    "#{league} Triple Crown Winner for #{year}: #{name}"
  end
end
