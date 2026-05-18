class CreateCupPoolMemberships < ActiveRecord::Migration[8.1]
  def change
    create_table :cup_pool_memberships do |t|
      t.references :cup_pool, null: false, foreign_key: true
      t.references :user,     null: false, foreign_key: true
      t.integer :total_score, null: false, default: 0
      t.integer :role,        null: false, default: 0
      t.timestamps
    end

    add_index :cup_pool_memberships, [ :cup_pool_id, :user_id ], unique: true
  end
end
