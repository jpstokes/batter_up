require 'csv'

unless ActiveRecord::Base.connection.table_exists? 'players'
  ActiveRecord::Schema.define do
    create_table :players do |t|
      t.column :player_id, :string
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :birth_year, :integer
    end

    add_index :players, :player_id
  end
end

unless ActiveRecord::Base.connection.table_exists? 'statistics'
  ActiveRecord::Schema.define do
    create_table :statistics do |t|
      t.column :player_id, :string
      t.column :year_id, :integer
      t.column :league, :string
      t.column :team_id, :string
      t.column :games, :integer
      t.column :at_bat, :integer
      t.column :runs, :integer
      t.column :hits, :integer
      t.column :doubles, :integer
      t.column :triples, :integer
      t.column :home_runs, :integer
      t.column :runs_batted_in, :integer
      t.column :stolen_bases, :integer
      t.column :caught_stealing, :integer
    end

    add_index :statistics, :player_id
  end
end
