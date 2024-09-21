class Attempt < ApplicationRecord
  belongs_to :student
  belongs_to :puzzle_type

  %i(problem_html solution_html).each do |content|
    validates content, absence: true, if: :queued?
    validates content, presence: true, unless: :queued?
  end
  validates :score, presence: true, if: :graded?

  after_create :generate_puzzle!

  scope :recent, -> { order(updated_at: :desc) }

  AttemptState.all.each do |possible_state|
    define_method "#{possible_state}?" do
      state == possible_state
    end
  end

  def generate_puzzle!
    GeneratePuzzleJob.enqueue(attempt_id: id)
  end

end
