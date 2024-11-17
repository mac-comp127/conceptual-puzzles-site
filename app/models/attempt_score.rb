DatabaseEnum.define(:attempt_score)

class AttemptScore
  def self.to_numeric(score)
    case score
      when AttemptScore.full_credit then 1.0
      when AttemptScore.almost      then 0.9
      when AttemptScore.half_credit then 0.5
      when AttemptScore.no_credit   then 0.0
      else raise "Unknown score: #{score.inspect}"
    end
  end
end
