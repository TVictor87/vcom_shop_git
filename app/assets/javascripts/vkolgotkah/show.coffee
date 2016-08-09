window.spinner_settings = (selector, max) ->
  if !(max == 0)
    selector.spinner("enable")
    selector.spinner('option', 'max', max)
    selector.spinner("value", '1')
  else
    selector.spinner("disable")
    selector.spinner("value", '0')

$ ->
  spinner_settings($('.spinner'), parseInt($('.spinner').data('max')))

  $(".fancybox").fancybox({
    openEffect	: 'none',
    closeEffect	: 'none'
  })

  $(document).on 'change', '.select-holder select', ->
    options = {}
    options['product_id'] = $('.form-product').data('productId')
    $('.select-holder select').each ->
      options[$(this).data('group-id')] = $(this).find('option:selected')[0].value
    $.ajax
      url: $('.select-holder').data('url')
      type: 'GET'
      dataType: 'script'
      data: options


      