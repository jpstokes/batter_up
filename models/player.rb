# file: player.rb
class Player < ActiveRecord::Base
  def self.find_players_by_at_bat_and_period(number_of_at_bats, from, to)
    player_ids = Statistic.where('year_id BETWEEN ? AND ?', from, to)
    .having('sum(at_bat) >= ?', number_of_at_bats)
    .group(:player_id).sum(:at_bat).map { |stat| stat[0] }
    Player.where(player_id: player_ids)
  end

  def self.find_players_by_team_and_year(team, year)
    player_ids = Statistic.where('team_id = ? and year_id = ?', team, year)
    .map(&:player_id).uniq
    Player.where(player_id: player_ids)
  end

  def self.highest_batting_average(players, year)
    highest = nil
    players.each do |player|
      highest = player if highest.nil?
      player_batting_average = player.batting_average(year, year)
      highest_player_batting_average = highest.batting_average(year, year)
      if player_batting_average > highest_player_batting_average
        highest = player
      end
    end
    highest
  end

  def self.most_home_runs(players, year)
    highest = nil
    players.each do |player|
      highest = player if highest.nil?
      player_home_runs = player.find_statistics(year, year).sum(:home_runs)
      highest_player_home_runs =
        highest.find_statistics(year, year).sum(:home_runs)
      highest = player if player_home_runs > highest_player_home_runs
    end
    highest
  end

  def self.most_rbi(players, year)
    highest = nil
    players.each do |player|
      highest = player if highest.nil?
      player_rbi = player.find_statistics(year, year).sum(:runs_batted_in)
      highest_player_rbi =
        highest.find_statistics(year, year).sum(:runs_batted_in)
      highest = player if player_rbi > highest_player_rbi
    end
    highest
  end

  def find_statistics(from, to)
    Statistic.where('(player_id = ?) and (year_id between ? and ?)',
                    player_id, from, to)
  end

  def batting_average(from, to)
    stats = find_statistics(from, to)
    hits = stats.sum('hits')
    at_bat = stats.sum('at_bat')
    result = hits / at_bat.to_f
    result.nan? ? 0.0 : result
  end

  def slugging_percentage(from, to)
    stats = find_statistics(from, to)
    hits = stats.sum(:hits)
    doubles = stats.sum(:doubles)
    triples = stats.sum(:triples)
    home_runs = stats.sum(:home_runs)
    at_bat = stats.sum(:at_bat)
    result = hits - doubles - triples - home_runs
    result = result + (2 * doubles) + (3 * triples) + (4 * home_runs)
    result /= at_bat.to_f
    result.nan? ? 0.0 : result
  end

  def played_in_league?(league, year)
    stat = find_statistics(year, year).first
    stat.nil? ? false : stat.league == league
  end
end
