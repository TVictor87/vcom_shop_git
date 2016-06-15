#= require ./bootstrap/js/bootstrap.min
#= require ./dist/js/app.min
#= require ./plugins/bootstrap-slider/bootstrap-slider
#= require ./plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.all.min
#= require ./plugins/datatables/jquery.dataTables.min
#= require ./plugins/datatables/dataTables.bootstrap.min
#= require ./plugins/iCheck/icheck.min
#= require ./plugins/select2/select2.full.min
#= require ./plugins/slimScroll/jquery.slimscroll.min

jQuery ->
  # Site language
  lang = $('html').attr('lang')

  # Autoclose success message
  $ ->
    setTimeout (->
      $('.flash-message .alert-success').hide 500
      $('.flash-message').hide 500
    ), 5000

  # Close bootstrap message
  $ ->
    $('button.close').click ->
      setTimeout (->
        $('.flash-message').hide()
      ), 200

  # Switching between tabs on the link. Example: "/admin/products/6/edit#img"
  $ ->
    if location.hash != ''
      $('a[href="'+location.hash+'"]').tab('show')

    $('a[data-toggle="tab"]').on 'shown', (e) ->
      location.hash = $(e.target).attr('href').substr(1)

  # iCheck plugin for checkbox
  $ ->
    $('input[type=checkbox]').iCheck
      checkboxClass: 'icheckbox_square-blue'
      radioClass: 'iradio_square-blue'
      increaseArea: '20%'

  # Select2 for select
  $ ->
    $('.select2').select2().change ->
      if $('.select2').val() != null
        select2 = $('.select2').closest('.form-group')
        select2.removeClass 'has-error'
        select2.find('span.help-block').remove()

  # Bootstrap-Wysihtml5 text editor for textarea
  $ ->
    $('textarea').wysihtml5 toolbar: html: true

  # DataTable fot tables
  $ ->
    $('.dataTable').DataTable
      language:
        url: '/assets/admin/AdminLTE/plugins/datatables/languages/' + lang + '.lang'
      dom:
        "<'row'<'col-sm-6'l><'col-sm-6'f>>" +
        "<'width-control'tr>" +
        "<'row'<'col-sm-5'i><'col-sm-7'p>>"
      aoColumnDefs: [{ bSortable: false, aTargets: [ -1 ] }]
      fnDrawCallback: ->
        if $('.content').find('.paginate_button').length <= 3
          $('.content div.dataTables_paginate')[0].style.display = 'none'
        else
          $('.content div.dataTables_paginate')[0].style.display = 'block'
        return
#      'paging': true
#      'lengthChange': false
#      'searching': false
#      'ordering': true
#      'info': true
#      'autoWidth': false
    return