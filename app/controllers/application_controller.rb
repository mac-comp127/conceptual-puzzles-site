class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def current_student
    @current_student ||=
      if Rails.env.development? && !ENV['test_student_id'].blank?
        Student.find(ENV['test_student_id'].to_i)
      elsif session[:student]
        Student.find(session[:student])
      else
        redirect_to login_path
      end
  end
  helper_method :current_student

  def student_authenticated!(student, avatar_url: nil)
    session[:student] = student.id
    session[:student_avatar] = avatar_url
  end
end
