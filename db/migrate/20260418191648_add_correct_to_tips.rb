class AddCorrectToTips < ActiveRecord::Migration[8.1]
  def change
    add_column :tips, :correct, :boolean
  end
end
