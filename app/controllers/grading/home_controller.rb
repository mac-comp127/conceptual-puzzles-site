class Grading::HomeController < Grading::BaseController
  def show
    @pending_attempts =
      Attempt
        .where(state: [AttemptState.available, AttemptState.submitted])
        .order(:created_at)

    @error_attempts =
      Attempt
        .where(state: AttemptState.generator_failed)
        .where('created_at > ?', 1.week.ago)
  end
end
