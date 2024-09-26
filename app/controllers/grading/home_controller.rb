class Grading::HomeController < Grading::BaseController
  def show
    redirect_to grading_attempts_path
  end
end
