class Grading::StudentPreviewModeController < Grading::BaseController
  def enter
    # Create a corresponding student role for the instructor
    student = Student.find_or_create_by!(email: current_instructor.email, cohort:)
    enter_student_preview_mode!(student)
    redirect_to(root_path)
  end
end
