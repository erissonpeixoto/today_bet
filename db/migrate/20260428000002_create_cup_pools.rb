class CreateCupPools < ActiveRecord::Migration[8.1]
  def change
    create_table :cup_pools do |t|
      t.string  :name,        null: false
      t.text    :description
      t.string  :invite_code, null: false
      t.references :creator,  null: false, foreign_key: { to_table: :users }
      t.boolean :private,     null: false, default: false
      t.integer :status,      null: false, default: 0
      t.timestamps
    end

    add_index :cup_pools, :invite_code, unique: true
  end
end
