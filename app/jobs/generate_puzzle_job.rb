class GeneratePuzzleJob < ApplicationJob
  def run(attempt_id:)
    Attempt.transaction do
      attempt = Attempt.find(attempt_id)
      raise "Cannot generate attempt when state is #{attempt.state}" unless attempt.queued?

      attempt.content = "Foo bar"
      attempt.state = AttemptState.available
      attempt.save!
    end
  end

  def log_level(elapsed)
    :info
  end
end
