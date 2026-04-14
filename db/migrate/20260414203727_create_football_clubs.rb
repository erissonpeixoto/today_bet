class CreateFootballClubs < ActiveRecord::Migration[8.1]
  def change
    create_table :football_clubs do |t|
      t.string :name,     null: false
      t.string :logo_url

      t.timestamps
    end

    add_index :football_clubs, :name, unique: true
  end
end
