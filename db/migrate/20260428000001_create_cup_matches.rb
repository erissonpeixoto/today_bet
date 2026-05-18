class CreateCupMatches < ActiveRecord::Migration[8.1]
  def change
    create_table :cup_matches do |t|
      t.references :home_club, null: false, foreign_key: { to_table: :football_clubs }
      t.references :away_club, null: false, foreign_key: { to_table: :football_clubs }
      t.string  :group_name
      t.integer :phase,      null: false, default: 0
      t.datetime :match_date, null: false
      t.integer :home_score
      t.integer :away_score
      t.integer :status,     null: false, default: 0
      t.string  :venue
      t.timestamps
    end

    add_index :cup_matches, :match_date
    add_index :cup_matches, :status
    add_index :cup_matches, :phase
  end
end
