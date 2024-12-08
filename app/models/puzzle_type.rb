class PuzzleType < ApplicationRecord
  has_many :cohort_puzzle_types
  has_many :cohorts, through: :cohort_puzzle_types
end
