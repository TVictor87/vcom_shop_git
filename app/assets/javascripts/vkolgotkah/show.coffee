$ ->
  $('.spinner').spinner('option', 'max', 1);
  $('.info-block select').on 'change', ->
    $.ajax
      url: ""
      data: data
      dataType: 'json'
      