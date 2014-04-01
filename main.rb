load 'config/ar.rb'

app = BatterUp.new

p 'Batting averages'
app.batting_averages(200, 2009, 2010).each { |ba| p ba }

p 'Slugging percentages'
app.slugging_percentages('OAK', 2007).each { |sp| p sp }

p app.triple_crown_winner('AL', 2011)
p app.triple_crown_winner('AL', 2012)
p app.triple_crown_winner('NL', 2011)
p app.triple_crown_winner('NL', 2012)
