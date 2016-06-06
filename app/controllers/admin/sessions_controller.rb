module Admin
  class SessionsController < Devise::SessionsController
    layout 'admin_sign_in'

    def create
      user = User.find_by_email(params[:admin_user][:email])
      if user
        if user.admin?
          super
        else
          flash[:alert] = t('devise.failure.not_admin')
          redirect_to new_admin_user_session_path
        end
      else
        # set_flash_message(:alert, :not_found_in_database)
        flash[:alert] = t('devise.failure.invalid')
        redirect_to new_admin_user_session_path
      end
    end

    protected

    def after_sign_in_path_for(_resource)
      admin_root_path
    end

    def after_sign_out_path_for(_resource_or_scope)
      new_admin_user_session_path
    end
  end
end
