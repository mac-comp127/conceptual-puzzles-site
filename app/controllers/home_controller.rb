class HomeController < ApplicationController
  def show
    redirect_to(
      if current_user.is_a?(Instructor)
        cohorts = current_user.cohorts.active
        if cohorts.count == 1
          grading_cohort_path(cohorts.first)
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
