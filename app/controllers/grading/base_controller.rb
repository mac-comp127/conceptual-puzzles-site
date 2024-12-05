class Grading::BaseController < ApplicationController
  before_action do
    require_login!(Instructor)
  end

  def cohort
    @cohort ||= Cohort.find(params[:cohort_id])
  end
  helper_method :cohort

  def cohort_attempts
    @cohort_attempts ||= Attempt.where(student: cohort.students)
  end
end
