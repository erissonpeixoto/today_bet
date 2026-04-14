class RemoveTeamStringsFromMatches < ActiveRecord::Migration[8.1]
  def change
    remove_column :matches, :home_team, :string
    remove_column :matches, :away_team, :string
  end
end
