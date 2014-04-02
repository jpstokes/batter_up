require 'spec_helper'

describe BatterUp do

  let(:app) { BatterUp.new }
  let!(:player_1) { FactoryGirl.create(:player) }
  let!(:player_2) do
    FactoryGirl.create(:player, first_name: 'James', player_id: 2)
  end

  describe '#batting_averages' do
    before { FactoryGirl.create(:statistic) }

    it 'should return an array' do
      expect(app.batting_averages(100, 2000, 2012)).to be_a_kind_of Array
    end

    context 'when within period' do
      it 'should return batting averages >= 100' do
        expect(app.batting_averages(100, 2000, 2013).count).to eq(1)
      end

      it 'should return correct string' do
        player = [
          "Name: #{player_1.first_name} #{player_1.last_name}, " \
          "Batting Avg: #{player_1.batting_average(2000, 2012)}"
        ]
        expect(app.batting_averages(100, 2000, 2012)).to eq(player)
      end
    end

    context 'when multiple players match criteria' do
      before { FactoryGirl.create(:statistic, player_id: player_2.player_id) }

      it 'should return batting averages >= 100' do
        expect(app.batting_averages(100, 2000, 2013).count).to eq(2)
      end

      it 'should return correct string array' do
        players = [
          "Name: #{player_1.first_name} #{player_1.last_name}, " \
          "Batting Avg: #{player_1.batting_average(2000, 2012)}"
        ]
        players << "Name: #{player_2.first_name} #{player_2.last_name}, " \
          "Batting Avg: #{player_2.batting_average(2000, 2012)}"
        expect(app.batting_averages(100, 2000, 2012)).to eq(players)
      end
    end

    context 'when outside of period' do
      it 'should return batting averages >= 100' do
        expect(app.batting_averages(100, 2000, 2011).count).to eq(0)
      end
    end

    context 'when below at_bat requirement of period' do
      it 'should not return any players' do
        expect(app.batting_averages(200, 2000, 2011).count).to eq(0)
      end
    end
  end

  describe '#slugging_percentages' do
    before { FactoryGirl.create(:statistic) }

    context 'when within year' do
      context 'when on specified team' do
        it 'returns player(s)' do
          expect(app.slugging_percentages('NYA', 2012).count).to eq(1)
        end

        it 'returns correct string array' do
          players = [
            "Name: #{player_1.first_name} #{player_1.last_name}, " \
            "Slugging Percentage: #{player_1.slugging_percentage(2012, 2012)}"
          ]
          expect(app.slugging_percentages('NYA', 2012)).to eq(players)
        end
      end

      context 'when not on specified team' do
        it 'returns player(s)' do
          expect(app.slugging_percentages('AA', 2012).count).to eq(0)
        end
      end
    end

    context 'when not within year' do
      it 'returns player(s)' do
        expect(app.slugging_percentages('NYA', 2013).count).to eq(0)
      end
    end
  end

  describe '#triple_crown_winner' do
    before { FactoryGirl.create(:statistic, at_bat: 400) }

    context 'when critieria met' do
      it 'displays the correct string' do
        expect(app.triple_crown_winner('AL', 2012))
          .to eq('AL Triple Crown Winner for 2012: john doe')
      end
    end

    context 'when criteria not met' do
      it 'displays no winner if no player in league won' do
        expect(app.triple_crown_winner('NL', 2012))
          .to eq('NL Triple Crown Winner for 2012: (No winner)')
      end

      it 'displays no winner if no player in year won' do
        expect(app.triple_crown_winner('AL', 2013))
          .to eq('AL Triple Crown Winner for 2013: (No winner)')
      end
    end
  end
end
