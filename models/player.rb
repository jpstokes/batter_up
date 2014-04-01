class Player < ActiveRecord::Base

  def self.find_players_by_at_bat(number_of_at_bats)
    player_ids = Statistic.where('at_bat >= ?', number_of_at_bats).map(&:player_id).uniq
    Player.where(:player_id => player_ids)
  end

  def self.find_players_by_team_and_year(team, year)
    player_ids = Statistic.where("team_id = ? and year_id = ?", team, year).map(&:player_id).uniq
    Player.where(:player_id => player_ids)
  end

  def self.highest_batting_average(players, year)
    highest = nil
    players.each do |player|
      if highest.nil?
        highest = player
      elsif player.batting_average(year, year) > highest.batting_average(year, year)
        highest = player
      end
    end
    highest
  end

  def self.most_home_runs(players, year)
    highest = nil
    players.each do |player|
      if highest.nil?
        highest = player
      elsif player.find_statistics(year, year).sum(:home_runs) > highest.find_statistics(year, year).sum(:home_runs)
        highest = player
      end
    end
    highest
  end

  def self.most_rbi(players, year)
    highest = nil
    players.each do |player|
      if highest.nil?
        highest = player
      elsif player.find_statistics(year, year).sum(:runs_batted_in) > highest.find_statistics(year, year).sum(:runs_batted_in)
        highest = player
      end
    end
    highest
  end

  def find_statistics(from, to)
    Statistic.where("(player_id = ?) and (year_id between ? and ?)", self.player_id, from, to)
  end

  def batting_average(from, to)
    stats = find_statistics(from, to)
    hits = stats.sum('hits')
    at_bat = stats.sum('at_bat')
    hits / at_bat.to_f
  end

  def slugging_percentage(from, to)
    stats = find_statistics(from, to)
    hits = stats.sum(:hits)
    doubles = stats.sum(:doubles)
    triples = stats.sum(:triples)
    home_runs = stats.sum(:home_runs)
    at_bat = stats.sum(:at_bat)
    ((hits - doubles - triples - home_runs) + (2 * doubles) + (3 * triples) + (4 * home_runs)) / at_bat.to_f
  end

  def played_in_league?(league, year)
    stat = find_statistics(year, year).first
    stat.nil? ? false : stat.league == league
  end
end
