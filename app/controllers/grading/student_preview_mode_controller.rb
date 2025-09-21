class Grading::StudentPreviewModeController < Grading::BaseController
  def enter
    # Create a corresponding student role for the instructor
    student = Student.find_or_initialize_by(email: current_instructor.email, cohort:)
    student.in_gradebook = false  # So as not to throw off stats
    student.save!

    enter_student_preview_mode!(student)

    flash[:notice] = <<~__EOS__
      You are viewing this page in preview mode, as a student would see it.
      You can fake-grade the attempts you generate here from the instructor interface, but those
      attempts will not show up in the roster / gradebook view, and will not affect class average.
      Use the button in the top nav bar to return to the instructor view.
    __EOS__
    redirect_to(root_path)
  end
end
