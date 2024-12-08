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
    Cohort.transaction do
      cohort.puzzle_type_ids = selected_puzzle_type_ids  # Will get rolled back if validation fails

      unless cohort.update(cohort_params)
        render :edit
        raise ActiveRecord::Rollback
      end

      redirect_to grading_cohort_path(cohort)
    ensure
    end
  end

  def cohort_param
    :id
  end

private

  def cohort_params
    params.require(:cohort).permit([:name, :start_date, :end_date, :instructor_id, :puzzle_score_denominator])
  end

  def selected_puzzle_type_ids
    (params[:puzzle_types] || {})
      .select { |id, options| p [id, options]; options[:enabled] }
      .keys
      .map(&:to_i)
  end

end
