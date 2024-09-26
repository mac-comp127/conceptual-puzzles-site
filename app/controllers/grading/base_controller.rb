class Grading::BaseController < ApplicationController
  before_action do
    require_login!(Instructor)
  end
end
