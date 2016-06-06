module ApplicationHelper
  def safe_translate(model, key, lang = locale)
    sanitize model.try("#{key}_#{lang}") || model.try("#{key}_ru")
  end
end
