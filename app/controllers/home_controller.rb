class HomeController < ApplicationController
  def show
    redirect_to(
      if current_user.is_a?(Instructor)
        if cohort = current_user.cohorts.first
          grading_cohort_path(cohort)
        else
          grading_cohorts_path
        end
      elsif current_user
        attempts_path
      else
        login_path
      end
    )
  end
end
