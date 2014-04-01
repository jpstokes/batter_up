FactoryGirl.define do
  factory :player do
    player_id  1
    first_name 'john'
    last_name  'doe'
    birth_year 1980
  end

  factory :statistic do
    player_id       1
    year_id         2012
    league          'AL'
    team_id         'NYA'
    games           100
    at_bat          100
    runs            100
    hits            200
    doubles         5
    triples         40
    home_runs       20
    runs_batted_in  100
    stolen_bases    50
    caught_stealing 25
  end
end
