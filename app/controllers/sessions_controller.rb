class SessionsController < ApplicationController
  def new
  end

  def create
    auth = request.env["omniauth.auth"]

    unless auth.info.email && auth.info.email_verified
      flash[:error] = "The email for your Google account is not verified. Please verify it, then try to log in again."
      return redirect_to login_path
    end

    unless auth.info.email =~ /@macalester.edu$/
      flash[:error] = "You must use your macalester.edu email to log in. Please do not use a different Google account."
      return redirect_to login_path
    end

    user = Instructor.find_by(email: auth.info.email)

    unless user
      user = Student.find_or_initialize_by(email: auth.info.email)
      user.name = auth.info.name
      user.save!
    end

    user_authenticated!(user, avatar_url: auth.info.image)

    redirect_to root_path
  end

  def destroy
    reset_session
    redirect_to root_path
  end
end
