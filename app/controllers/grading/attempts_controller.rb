class Grading::AttemptsController < Grading::BaseController
  def index
    @attempts = cohort_attempts

    params[:state] ||= 'all'
    unless params[:state] == 'all'
      @attempts = @attempts.where(state: params[:state])
    end
  end

  def show
  end

  def update
    attempt.grading_status = params[:attempt][:grading_status]
    attempt.save!

    update_desc = [attempt.state, attempt.score].compact.join(", ")
    flash[:notice] = "Puzzle #{attempt.lookup_code} status updated: #{update_desc}"

    redirect_to grading_attempt_path(attempt)
  end

private

  def attempt
    @attempt ||= Attempt.find(params[:id])
  end
  helper_method :attempt
end
