module Admin
  class SessionsController < Devise::SessionsController
    layout 'admin_sign_in'

    def create
      user = achieve_user
      if user
        if user.admin?
          super
        else
          redirect_to devise_failure 'not_admin'
        end
      else
        redirect_to devise_failure 'invalid'
      end
    end

    protected

    def devise_failure(name)
      flash[:alert] = t("devise.failure.#{name}")
      new_admin_user_session_path
    end

    def achieve_user
      User.find_by_email(params[:admin_user][:email])
    end

    def after_sign_in_path_for(_resource)
      admin_root_path
    end

    def after_sign_out_path_for(_resource_or_scope)
      new_admin_user_session_path
    end
  end
end
