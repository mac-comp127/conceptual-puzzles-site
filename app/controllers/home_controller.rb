class HomeController < ApplicationController
  before_action :require_student_login!

  def show
    puts helpers.current_student
  end
end
