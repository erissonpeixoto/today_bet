class CreateVotes < ActiveRecord::Migration[8.1]
  def change
    create_table :votes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :tip,  null: false, foreign_key: true
      t.integer :vote_type, null: false

      t.timestamps
    end

    add_index :votes, [:user_id, :tip_id, :vote_type], unique: true
  end
end
