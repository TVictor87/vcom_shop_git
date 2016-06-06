module Admin
  class BaseController < ApplicationController
    before_filter :set_admin_language, :authenticate_admin!
    helper_method :page_title, :admin_name

    layout 'admin'

    def page_title
      t("admin.#{controller_name}.title")
    end

    def admin_name
      "#{current_admin_user.first_name} #{current_admin_user.last_name}"
    end

    private

    def set_admin_language
      I18n.locale = :ru
    end

    def authenticate_admin!
      authenticate_admin_user!

      unless current_admin_user && current_admin_user.admin?
        sign_out current_admin_user

        redirect_to(new_admin_user_session_path) && return
      end
    end
  end
end
