class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # def set_admin_language
  #   I18n.locale = :ru
  # end

  private

  def locate_key(key, lang = I18n.locale)
    "#{key}_#{lang}"
  end

  def render_404
    render file: "public/404.html", status: 404
  end
end
