class CreateMatches < ActiveRecord::Migration[8.1]
  def change
    create_table :matches do |t|
      t.string   :home_team,  null: false
      t.string   :away_team,  null: false
      t.string   :league,     null: false
      t.datetime :match_date, null: false
      t.integer  :status,     null: false, default: 0

      t.timestamps
    end

    add_index :matches, :match_date
    add_index :matches, :status
  end
end
