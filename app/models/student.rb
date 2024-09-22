class Student < ApplicationRecord
  has_many :attempts

  def puzzle_statuses
    PuzzleType.enabled.map do |puzzle_type|
      puzzle_status_for(puzzle_type:)
    end
  end

  def puzzle_status_for(puzzle_type:)
    attempts_for_type = attempts.where(puzzle_type:)
    latest_attempt = attempts_for_type.recent.first
    StudentPuzzleStatus[
      puzzle_type:,
      score: attempts_for_type.where(state: :graded).maximum(:score),
      latest_attempt:,
      new_attempt_allowed: (
        [AttemptState.graded, AttemptState.generator_failed, nil].include?(latest_attempt&.state) &&
        latest_attempt&.score != AttemptScore.full_credit
      )
    ]
  end
end
