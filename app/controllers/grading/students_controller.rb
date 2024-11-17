class Grading::StudentsController < Grading::BaseController
  def index
    @students = Student.all.includes(attempts: :puzzle_type)
  end

  def show
  end

private

  def student
    @student ||= Student.find(params[:id])
  end
  helper_method :student

  def all_scores_for(puzzle_type:)
    @students.map { |s| s.puzzle_status_for(puzzle_type:).numeric_score }
  end
  helper_method :all_scores_for

  def all_total_scores
    @students.map(&:total_score)
  end
  helper_method :all_total_scores

  def mean(values)
    values.sum.to_f / values.count
  end
  helper_method :mean

  def median(values)
    return 0.0/0 if values.empty?
    sorted = values.sort
    (
      sorted[sorted.count / 2].to_f +
      sorted[(sorted.count - 1) / 2].to_f
    ) / 2
  end
  helper_method :median
end
