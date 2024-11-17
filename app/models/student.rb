class Student < ApplicationRecord
  has_many :attempts

  def username
    email.sub("@macalester.edu", "")
  end

  def display_name
    name || email
  end

  def puzzle_statuses
    @puzzle_statuses ||= PuzzleType.enabled.map do |puzzle_type|
      puzzle_status_for(puzzle_type:)
    end
  end

  def puzzle_status_for(puzzle_type:)
    attempts_for_type =
      attempts
        .select { |a| a.puzzle_type == puzzle_type }
        .sort_by(&:created_at)
        .reverse
    latest_attempt = attempts_for_type.first
    StudentPuzzleStatus[
      puzzle_type:,
      score: attempts_for_type
        .select { |a| a.state == AttemptState.graded }
        .map(&:score)
        .max_by { |s| AttemptScore.to_numeric(s) } || AttemptScore.no_credit,
      attempts: attempts_for_type,
      latest_attempt:,
      new_attempt_allowed: (
        [AttemptState.graded, AttemptState.generator_failed, nil].include?(latest_attempt&.state) &&
        latest_attempt&.score != AttemptScore.full_credit
      )
    ]
  end

  def total_score
    puzzle_statuses.map(&:numeric_score).sum / PuzzleType.count
  end
end
