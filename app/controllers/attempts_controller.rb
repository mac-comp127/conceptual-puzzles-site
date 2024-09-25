class AttemptsController < ApplicationController
  before_action do
    require_login!(Student)
  end

  def index
  end

  def create
    Attempt.transaction do
      puzzle_type = PuzzleType.find(params[:attempt][:puzzle_type])

      status = current_student.puzzle_status_for(puzzle_type:)
      attempt = if status.new_attempt_allowed
        current_student.attempts.create!(puzzle_type:)
      else
        status.latest_attempt
      end

      redirect_to attempt_path(attempt)
    end
  end

  def show
    @attempt = Attempt.find(params[:id])
    unless @attempt.student == current_student
      redirect_to root_url
    end
  end

private

  attr_reader :attempt
  helper_method :attempt

  def new_attempt_allowed?
    current_student == attempt.student &&
      attempt.student
        .puzzle_status_for(puzzle_type: attempt.puzzle_type)
        .new_attempt_allowed
  end
  helper_method :new_attempt_allowed?
end
