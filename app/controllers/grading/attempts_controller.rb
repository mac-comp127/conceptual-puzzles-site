class Grading::AttemptsController < Grading::BaseController
  def index
    @attempts = Attempt.all

    params[:state] ||= 'submitted'
    unless params[:state] == 'all'
      @attempts = @attempts.where(state: params[:state])
    end
  end

  def show
  end

private

  def attempt
    @attempt ||= Attempt.find(params[:id])
  end
  helper_method :attempt
end
