class AttemptsController < ApplicationController
  before_action :require_student_login!

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
end
