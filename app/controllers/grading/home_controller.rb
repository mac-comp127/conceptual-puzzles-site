class Grading::HomeController < ApplicationController
  before_action do
    require_login!(Instructor)
  end

  def show
    
  end
end
