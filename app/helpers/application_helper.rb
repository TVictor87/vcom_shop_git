module ApplicationHelper
  def safe_translate(model, key, lang = locale)
    sanitize model.try("#{key}_#{lang}") || model.try("#{key}_ru")
  end

  def disabled(group_id, id)
    return '' unless @available_options
    arr = @available_options[group_id] or @available_options[:all]
    if arr[id] or @checked_options_map[id] then '' else " disabled='disabled'" end
  end
end
