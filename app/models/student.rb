class Student < ApplicationRecord
  has_many :attempts

  def puzzle_statuses
    @puzzle_statuses ||= PuzzleType.enabled.map do |puzzle_type|
      puzzle_status_for(puzzle_type:)
    end
  end

  def puzzle_status_for(puzzle_type:)
    attempts_for_type = attempts.where(puzzle_type:)
    latest_attempt = attempts_for_type.recent.first
    StudentPuzzleStatus[
      puzzle_type:,
      score: attempts_for_type.where(state: AttemptState.graded).maximum(:score) || AttemptScore.no_credit,
      attempts: attempts_for_type,
      latest_attempt:,
      new_attempt_allowed: (
        [AttemptState.graded, AttemptState.generator_failed, nil].include?(latest_attempt&.state) &&
        latest_attempt&.score != AttemptScore.full_credit
      )
    ]
  end

  def total_score
    puzzle_statuses.map { |status| AttemptScore.to_numeric(status.score) }.sum / PuzzleType.count
  end
end
