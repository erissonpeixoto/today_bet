class AddClubsToMatches < ActiveRecord::Migration[8.1]
  def change
    add_reference :matches, :home_club, null: true, foreign_key: { to_table: :football_clubs }
    add_reference :matches, :away_club, null: true, foreign_key: { to_table: :football_clubs }
  end
end
