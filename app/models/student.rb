class Student < ApplicationRecord
  has_many :attempts
  belongs_to :cohort, optional: true

  def username
    email.sub("@macalester.edu", "")
  end

  def display_name
    name || email
  end

  def puzzle_statuses
    @puzzle_statuses ||= puzzle_types.map do |puzzle_type|
      puzzle_status_for(puzzle_type:)
    end
  end

  def unused_puzzle_statuses
    @unused_puzzle_statuses ||=
      (PuzzleType.all - puzzle_types)
        .map { |puzzle_type| puzzle_status_for(puzzle_type:) }
        .select { |status| status.attempts.any? }
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

  def puzzle_score_denominator
    cohort&.puzzle_score_denominator || puzzle_types.count
  end

  def total_score
    return nil if puzzle_score_denominator == 0
    [puzzle_statuses.map(&:numeric_score).sum / puzzle_score_denominator.to_f, 1].min
  end

  def puzzle_types
    cohort&.puzzle_types || PuzzleType.all
  end
end
