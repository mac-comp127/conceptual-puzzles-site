class Attempt < ApplicationRecord
  belongs_to :student
  belongs_to :puzzle_type

  %i(problem_html solution_html).each do |content|
    validates content, absence: true, unless: :generated?
    validates content, presence: true, if: :generated?
  end
  validates :score, presence: true, if: :graded?

  after_create :generate_puzzle!

  scope :recent, -> { order(updated_at: :desc) }

  AttemptState.all.each do |possible_state|
    define_method "#{possible_state}?" do
      state == possible_state
    end
  end

  # The lookup code we give students is the attempt ID plus a few random check digits to catch
  # human transcription errors.
  #
  def generate_lookup_code!
    check_digit_mult = 10 ** CHECK_DIGIT_COUNT
    self.lookup_code = self.id * check_digit_mult + rand(check_digit_mult)
  end
  CHECK_DIGIT_COUNT = 2

  def generated?
    !(queued? || generator_failed?)
  end

  def generate_puzzle!
    GeneratePuzzleJob.enqueue(attempt_id: id)
  end

  # Grading status folds state and score together to serve the grading process

  def grading_status
    if available?
      :not_submitted
    elsif submitted?
      :submitted
    elsif graded?
      score
    end
  end

  def grading_status=(status)
    self.state, self.score =
      case status.to_sym
        when :not_submitted
          [AttemptState.available, nil]
        when :submitted
          [AttemptState.submitted, nil]
        else
          [:graded, status]
      end
  end
end
