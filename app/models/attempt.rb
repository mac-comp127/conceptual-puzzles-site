class Attempt < ApplicationRecord
  belongs_to :student
  belongs_to :puzzle_type
end
