module ApplicationHelper
  def safe_translate(model, key, lang = locale)
    sanitize model.try("#{key}_#{lang}") || model.try("#{key}_ru")
  end

  def disabled(group_id, id)
    return '' unless @available_options
    g = @available_options[group_id]
    if g
      return '' if g == true
      arr = g
    else
      arr = @available_options[:all]
    end
    if arr[id] then '' else " disabled='disabled'" end
  end
end
