class HomeController < ApplicationController
  def show
    redirect_to(
      if current_student
        attempts_path
      else
        login_path
      end
    )
  end
end
