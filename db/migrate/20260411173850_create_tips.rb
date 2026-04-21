class CreateTips < ActiveRecord::Migration[8.1]
  def change
    create_table :tips do |t|
      t.references :user,  null: false, foreign_key: true
      t.references :match, null: false, foreign_key: true
      t.integer :market,               null: false
      t.integer :confidence,           null: false, default: 0
      t.text    :justification,        null: false
      t.integer :votes_agree_count,    null: false, default: 0
      t.integer :votes_disagree_count, null: false, default: 0
      t.integer :votes_hot_count,      null: false, default: 0
      t.integer :comments_count,       null: false, default: 0

      t.timestamps
    end

    add_index :tips, [ :match_id, :votes_hot_count ]
    add_index :tips, [ :match_id, :votes_agree_count ]
    add_index :tips, [ :match_id, :comments_count ]
    add_index :tips, [ :match_id, :confidence ]
    add_index :tips, [ :user_id, :match_id, :market ], unique: true
  end
end
