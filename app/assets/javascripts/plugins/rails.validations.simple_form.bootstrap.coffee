#= require rails.validations

# Client Side Validations - SimpleForm - Bootstrap3 - v3.1.0
ClientSideValidations.formBuilders['SimpleForm::FormBuilder'] =
  add: (element, settings, message) ->
    errorElement = element.parent().find "#{settings.error_tag}.#{settings.error_class}"
    if not errorElement[0]?
      wrapper_tag_element = element.closest(settings.wrapper_tag)
      errorElement = $("<#{settings.error_tag}/>", { class: settings.error_class, text: message })
      wrapper_tag_element.append(errorElement)
    wrapper_class_element = element.closest(".#{settings.wrapper_class}");
    wrapper_class_element.addClass(settings.wrapper_error_class)
    errorElement.text(message)
  remove: (element, settings) ->
    wrapper_tag_element = element.closest(settings.wrapper_tag)
    wrapper_tag_element.removeClass(settings.wrapper_error_class)
    errorElement = wrapper_tag_element.find("#{settings.error_tag}.#{settings.error_class}")
    errorElement.remove()