class CreateCohortPuzzleTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :cohort_puzzle_types do |t|
      t.belongs_to :cohort, null: false, foreign_key: true
      t.belongs_to :puzzle_type, null: false, foreign_key: true
      t.timestamps

      t.index [:cohort_id, :puzzle_type_id], unique: true
    end

    remove_column :puzzle_types, :enabled, :boolean, default: true
  end
end
