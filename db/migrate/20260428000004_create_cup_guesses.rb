class CreateCupGuesses < ActiveRecord::Migration[8.1]
  def change
    create_table :cup_guesses do |t|
      t.references :cup_pool,  null: false, foreign_key: true
      t.references :cup_match, null: false, foreign_key: true
      t.references :user,      null: false, foreign_key: true
      t.integer :home_score_guess, null: false
      t.integer :away_score_guess, null: false
      t.integer :points_earned,    null: false, default: 0
      t.boolean :locked,           null: false, default: false
      t.timestamps
    end

    add_index :cup_guesses, [ :cup_pool_id, :cup_match_id, :user_id ], unique: true
  end
end
