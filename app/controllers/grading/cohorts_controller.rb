class Grading::CohortsController < Grading::BaseController
  def index
    @cohorts = Cohort
      .order(start_date: :desc, created_at: :desc)
      .includes(:instructor)
  end

  def show
    @pending_attempts =
      cohort_attempts
        .where(state: [AttemptState.available, AttemptState.submitted])
        .order(:created_at)

    @error_attempts =
      cohort_attempts
        .where(state: AttemptState.generator_failed)
        .where('created_at > ?', 1.week.ago)
  end

  def new
    @cohort = Cohort.new
    render :edit
  end

  def edit
  end

  def create
    @cohort = Cohort.new
    update
  end

  def update
    unless cohort.update(cohort_params)
      return render :edit
    end
    redirect_to grading_cohort_path(cohort)
  end

  def cohort_param
    :id
  end

private

  def cohort_params
    params.require(:cohort).permit([:name, :start_date, :end_date, :instructor_id])
  end

end
