class AddDisplayOrderToPuzzleTypes < ActiveRecord::Migration[7.2]
  def change
    add_column :puzzle_types, :display_order, :integer, default: 0, null: false
  end
end
