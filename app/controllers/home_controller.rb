class HomeController < ApplicationController
  def show
    redirect_to(
      if current_user.is_a?(Instructor)
        grading_path
      elsif current_user
        attempts_path
      else
        login_path
      end
    )
  end
end
