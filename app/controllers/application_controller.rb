class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def require_student_login!
    redirect_to login_path unless current_student
  end

  def current_student
    @current_student ||=
      if Rails.env.development? && !ENV['test_student_id'].blank?
        Student.find(ENV['test_student_id'].to_i)
      elsif session[:student]
        Student.find(session[:student])
      else
        nil
      end
  end
  helper_method :current_student

  def current_student_avatar
    session[:student_avatar]
  end
  helper_method :current_student_avatar

  def student_authenticated!(student, avatar_url: nil)
    session[:student] = student.id
    session[:student_avatar] = avatar_url
  end

  def puzzle_statuses(student)
    PuzzleType.enabled.map do |puzzle_type|
      attempts = student.attempts.where(puzzle_type:)
      PuzzleStatus[
        puzzle_type:,
        current_score: describe_score(attempts.where(state: :graded).maximum(:score)),
        status: describe_state(attempts.recent.first&.state)
      ]
    end
  end
end
