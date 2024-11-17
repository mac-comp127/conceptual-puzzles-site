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
end
