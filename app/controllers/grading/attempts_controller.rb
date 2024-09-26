class Grading::AttemptsController < Grading::BaseController
  def index
    @attempts = Attempt.all

    params[:state] ||= 'submitted'
    unless params[:state] == 'all'
      @attempts = @attempts.where(state: params[:state])
    end
  end
end
