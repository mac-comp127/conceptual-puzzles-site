class AddPuzzleScoreDenominatorToCohort < ActiveRecord::Migration[7.2]
  def change
    add_column :cohorts, :puzzle_score_denominator, :integer
  end
end
