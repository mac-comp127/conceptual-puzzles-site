class ApplicationController < ActionController::Base
  allow_browser versions: { safari: 15.4, chrome: 105, firefox: 121, opera: 91, ie: false }

  def require_login!(user_type)
    if current_user&.is_a?(user_type)
      @validated_user_type = user_type
    else
      redirect_to login_path
    end
  end

  [Student, Instructor].each do |user_type|
    method_name = :"current_#{user_type.name.downcase}"
    define_method method_name do
      unless @validated_user_type == user_type
        raise "Cannot call #{method_name} without first calling require_login!(#{user_type})"
      end
      unless current_user.is_a?(user_type)
        raise "Current user #{user.class} does not match validated user type #{user_type}"
      end
      current_user
    end
    helper_method method_name
  end

  def current_user
    @current_user ||= lambda do
      if Rails.env.development?
        test_user = ENV["test_user"]
        unless test_user.blank?
          model, id = test_user.split(':')
          return model.constantize.find(id)
        end
      end

      user_type = session[:user_type]&.constantize
      return nil unless [Instructor, Student].include?(user_type)
      return user_type.find(session[:user])
    end.call
  end
  helper_method :current_user

  def current_user_avatar
    session[:user_avatar]
  end
  helper_method :current_user_avatar

  def user_authenticated!(user, avatar_url: nil)
    session[:user] = user.id
    session[:user_type] = user.class.name
    session[:user_avatar] = avatar_url
  end
end
