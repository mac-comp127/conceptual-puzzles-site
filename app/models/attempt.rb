class Attempt < ApplicationRecord
  belongs_to :student
  belongs_to :puzzle_type

  validates :content, absence: true, if: :queued?
  validates :content, presence: true, unless: :queued?
  validates :score, presence: true, if: :graded?

  AttemptState.all.each do |possible_state|
    define_method "#{possible_state}?" do
      state == possible_state
    end
  end
end
