require 'spec_helper'
require_relative '../models/player.rb'

describe Player do
  before { @player = FactoryGirl.create(:player) }

  describe '#new' do
    it { expect(@player).to be_a_kind_of Player }
  end

  describe '#find_players_by_at_bat_and_period' do

    context 'when player is within period' do
      context 'when player with at_bat less than 200' do
        before { FactoryGirl.create(:statistic, at_bat: 199) }
        it 'equals 0' do
          expect(
            Player.find_players_by_at_bat_and_period(200, 2000, 2014).count
          ).to eq(0)
        end
      end

      context 'when player with at_bat of 200' do
        before { FactoryGirl.create(:statistic, at_bat: 200) }
        it 'equals 1' do
          expect(
            Player.find_players_by_at_bat_and_period(200, 2000, 2014).count
          ).to eq(1)
        end
      end

      context 'when player with at_bat over 200' do
        before { FactoryGirl.create(:statistic, at_bat: 201) }
        it 'equals 1' do
          expect(
            Player.find_players_by_at_bat_and_period(200, 2000, 2014).count
          ).to eq(1)
        end
      end

      context 'when adding mulitple statistics' do
        before do
          FactoryGirl.create(:player, first_name: 'Jackie', player_id: 2)
          FactoryGirl.create(:statistic, at_bat: 20)
          FactoryGirl.create(:statistic, at_bat: 30)
          FactoryGirl.create(:statistic, at_bat: 50)
          FactoryGirl.create(:statistic, at_bat: 40)
          FactoryGirl.create(:statistic, at_bat: 60)

          FactoryGirl.create(:statistic, player_id: 2, at_bat: 40)
          FactoryGirl.create(:statistic, player_id: 2, at_bat: 60)
        end

        context 'when player at_bat adds up to 100' do
          it 'equals 2' do
            expect(
              Player.find_players_by_at_bat_and_period(100, 2000, 2014).count
            ).to eq(2)
          end

          it 'returns the correct users' do
            expect(
              Player.find_players_by_at_bat_and_period(100, 2000, 2014)
              .map(&:first_name)
            ).to include('john', 'Jackie')
          end
        end

        context 'when player at_bat adds up to 200' do
          it 'equals 1' do
            expect(
              Player.find_players_by_at_bat_and_period(200, 2000, 2014).count
            ).to eq(1)
          end

          it 'returns the correct user' do
            expect(
              Player.find_players_by_at_bat_and_period(200, 2000, 2014)
                .first.first_name
            ).to eq('john')
          end
        end

        context 'when player at_bat adds up to 300' do
          it 'equals 1' do
            expect(
              Player.find_players_by_at_bat_and_period(300, 2000, 2014).count
            ).to eq(0)
          end
        end
      end
    end

    context 'when player is not within range' do
      it 'it does not show player' do
        expect(
          Player.find_players_by_at_bat_and_period(100, 2000, 2011).count
        ).to eq(0)
      end
    end
  end

  describe '#find_statistics' do
    context 'when year is within range' do
      it 'returns count of 1' do
        FactoryGirl.create(:statistic, year_id: 2001)
        expect(@player.find_statistics(2000, 2002).count).to eq(1)
      end
    end

    context 'when year is outside range' do
      it 'returns count of 0' do
        FactoryGirl.create(:statistic, year_id: 2003)
        expect(@player.find_statistics(2000, 2002).count).to eq(0)
      end
    end

    context 'when multiple stats within range' do
      it 'returns number of stats' do
        FactoryGirl.create(:statistic, year_id: 2000)
        FactoryGirl.create(:statistic, year_id: 2001)
        FactoryGirl.create(:statistic, year_id: 2002)
        expect(@player.find_statistics(2000, 2002).count).to eq(3)
      end
    end
  end

  describe '#batting_average' do
    before do
      FactoryGirl.create(:statistic, hits: 1, at_bat: 10, year_id: 2001)
      FactoryGirl.create(:statistic, hits: 1, at_bat: 05, year_id: 2001)
      FactoryGirl.create(:statistic, hits: 3, at_bat: 05, year_id: 2001)
    end

    it 'returns a float' do
      expect(@player.batting_average(2000, 2002)).to be_a_kind_of Float
    end

    it 'returns correct value' do
      expect(@player.batting_average(2000, 2002)).to eq(5.0 / 20.0)
    end
  end

  describe '#find_players_by_team_and_year' do
    before do
      FactoryGirl.create(:statistic, team_id: 'titans',   year_id: 2006)
      FactoryGirl.create(:statistic, team_id: 'panthers', year_id: 2003)

      FactoryGirl.create(:player, player_id: 2)
      FactoryGirl.create(
        :statistic, player_id: 2, team_id: 'panthers', year_id: 2003
      )
      FactoryGirl.create(
        :statistic, player_id: 2, team_id: 'dolphins', year_id: 2007
      )
    end

    context 'when team and year match' do
      it 'returns all matching players' do
        expect(
          Player.find_players_by_team_and_year('panthers', 2003).count
        ).to eq(2)
      end
    end

    context 'when team does not match' do
      it 'does not return player' do
        expect(
          Player.find_players_by_team_and_year('titans', 2003).count
        ).to eq(0)
      end
    end

    context 'when year does not match' do
      it 'does not return player' do
        expect(
          Player.find_players_by_team_and_year('panthers', 2001).count
        ).to eq(0)
      end
    end
  end

  describe '#slugging_percentage' do
    it 'return a float' do
      expect(@player.slugging_percentage(2000, 2002)).to be_a_kind_of Float
    end
  end

  describe '#highest_batting_average' do
    before do
      @player_1 = FactoryGirl
        .create(:player, player_id: 3, first_name: 'James')
      @player_2 = FactoryGirl
        .create(:player, player_id: 4, first_name: 'Joseph')
      @player_3 = FactoryGirl
        .create(:player, player_id: 5, first_name: 'Jude')

      FactoryGirl
        .create(:statistic, player_id: 3, hits: 20, at_bat: 30, year_id: 2000)
      FactoryGirl
        .create(:statistic, player_id: 4, hits: 25, at_bat: 30, year_id: 2000)
      FactoryGirl
        .create(:statistic, player_id: 5, hits: 28, at_bat: 30, year_id: 2000)
    end

    it 'chooses the player with the highest batting average' do
      expect(
        Player.highest_batting_average([@player_1, @player_2, @player_3], 2000)
          .first_name
      ).to eq('Jude')
    end
  end

  describe '#most_home_runs' do
    before do
      @player_1 =
          FactoryGirl.create(:player, player_id: 3, first_name: 'James')
      @player_2 =
        FactoryGirl.create(:player, player_id: 4, first_name: 'Joseph')
      @player_3 =
        FactoryGirl.create(:player, player_id: 5, first_name: 'Jude')

      FactoryGirl.create(
        :statistic, player_id: 3, home_runs: 20, at_bat: 30, year_id: 2000
      )
      FactoryGirl.create(
        :statistic, player_id: 4, home_runs: 25, at_bat: 30, year_id: 2000
      )
      FactoryGirl.create(
        :statistic, player_id: 5, home_runs: 28, at_bat: 30, year_id: 2000
      )
    end

    it 'chooses the player with the highest batting average' do
      expect(
        Player.most_home_runs([@player_1, @player_2, @player_3], 2000)
          .first_name
      ).to eq('Jude')
    end
  end

  describe '#most_rbi' do
    before do
      @player_1 = FactoryGirl.create(
        :player, player_id: 3, first_name: 'James'
      )
      @player_2 = FactoryGirl.create(
        :player, player_id: 4, first_name: 'Joseph'
      )
      @player_3 = FactoryGirl.create(
        :player, player_id: 5, first_name: 'Jude'
      )

      FactoryGirl.create(
        :statistic, player_id: 3, runs_batted_in: 20, at_bat: 30, year_id: 2000
      )
      FactoryGirl.create(
        :statistic, player_id: 4, runs_batted_in: 25, at_bat: 30, year_id: 2000
      )
      FactoryGirl.create(
        :statistic, player_id: 5, runs_batted_in: 28, at_bat: 30, year_id: 2000
      )
    end

    it 'chooses the player with the highest batting average' do
      expect(
        Player.most_rbi([@player_1, @player_2, @player_3], 2000).first_name
      ).to eq('Jude')
    end
  end

  describe '#played_in_league?' do
    before { FactoryGirl.create(:statistic, league: 'AL', year_id: 2012) }
    it { expect(@player.played_in_league?('AL', 2012)).to be_true }
  end

end
