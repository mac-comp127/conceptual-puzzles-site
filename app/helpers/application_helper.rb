PuzzleStatus = Data.define(:puzzle_type, :current_score, :status)

module ApplicationHelper
  def puzzle_statuses(student)
    PuzzleType.enabled.map do |puzzle_type|
      attempts = student.attempts.where(puzzle_type:)
      PuzzleStatus[
        puzzle_type:,
        current_score: describe_score(attempts.where(state: :graded).maximum(:score)),
        status: describe_state(attempts.recent.first&.state)
      ]
    end
  end

private

  def describe_score(score)
    case score
      when nil                      then "Not attempted yet"
      when AttemptScore.no_credit   then "No points yet"
      when AttemptScore.half_credit then "Half credit"
      when AttemptScore.full_credit then "Full credit"
    end
  end

  def describe_state(attempt_state)
    case attempt_state
      when nil                    then ""
      when AttemptState.queued    then "Generating…"
      when AttemptState.available then "Awaiting your solution"
      when AttemptState.submitted then "Submitted for grading"
      when AttemptState.graded    then "Graded"
    end
  end
end
