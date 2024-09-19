class HomeController < ApplicationController
  def show
    puts helpers.current_student
  end
end
