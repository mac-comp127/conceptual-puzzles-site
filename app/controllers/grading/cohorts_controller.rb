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
      unless cohort.update(cohort_params)
        return render :edit
      end

      update_puzzle_types!

      redirect_to grading_cohort_path(cohort)
    end
  end

  def cohort_param
    :id
  end

private

  def cohort_params
    params.require(:cohort).permit([:name, :start_date, :end_date, :instructor_id, :puzzle_score_denominator])
  end

  def update_puzzle_types!
    now_enabled = cohort.puzzle_type_ids

    to_enable = (params[:puzzle_types] || {})
      .select { |id, options| p [id, options]; options[:enabled] }
      .keys
      .map(&:to_i)

    to_add = to_enable - now_enabled
    to_remove = now_enabled - to_enable

    to_remove.each do |puzzle_type_id|
      cohort.cohort_puzzle_types.where(puzzle_type_id:).destroy_all
    end

    to_add.each do |puzzle_type_id|
      cohort.cohort_puzzle_types.create!(puzzle_type_id:)
    end
  end

end
