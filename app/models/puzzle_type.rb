class PuzzleType < ApplicationRecord
  scope :enabled, -> { where(enabled: true) }
end
