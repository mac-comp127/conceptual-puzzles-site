# The current net status of one student’s attempts for a particular puzzle type
#
StudentPuzzleStatus = Data.define(
  :puzzle_type, 
  :score,
  :attempts,
  :latest_attempt,
  :new_attempt_allowed,
) do
  def numeric_score
    AttemptScore.to_numeric(score)
  end
end
