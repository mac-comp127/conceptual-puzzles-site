class Grading::AttemptsController < ApplicationController
  def index
    @attempts = Attempt.all

    params[:state] ||= 'submitted'
    unless params[:state] == 'all'
      @attempts = @attempts.where(state: params[:state])
    end
  end
end
