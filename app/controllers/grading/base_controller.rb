class Grading::BaseController < ApplicationController
  before_action do
    require_login!(Instructor)
  end

  def cohort
    @cohort ||= Cohort.find(params[cohort_param])
  end
  helper_method :cohort

  def cohort_param
    :cohort_id  # controllers override this when param is just :id
  end

  def cohort_attempts
    @cohort_attempts ||= Attempt.where(student: cohort.students)
  end
end
