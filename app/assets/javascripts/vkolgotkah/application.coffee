# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
# about supported directives.
#
#############################
# require jquery            #
# require fancybox          #
# require twitter/bootstrap #
# require bootstrap         #
# require vkolgotkah/main   #
# require_tree .            #
#############################

#= require ./jquery-1.8.3.min
#= require ./jquery.open-close
#= require ./jquery.fancybox
#= require ./jquery.tabs
#= require ./jquery.carousel
#= require ./jquery.custom.forms
#= require ./jquery.ui.widget.js
#= require ./jquery.ui.button.js
#= require ./jquery.ui.spinner.js
#= require ./jquery.ui.slider.js
#= require ./jquery.main

#= require jquery.turbolinks

ready = ->
	$('.grayscale').gray();


$(document).ready ready
$(document).on 'page:load', ready


Number.prototype.toCurrency = ->
	(""+@toFixed(2)).replace(/\B(?=(\d{3})+(?!\d))/g, " ")

Number.prototype.productPrice = ->
	switch currency
		when 'UAH'
			"<b>#{(""+(@ / course).toFixed(2)).replace(/\B(?=(\d{3})+(?!\d))/g, " ")}</b> грн"
		when 'USD'
			"$<b>#{(""+(@ / course).toFixed(2)).replace(/\B(?=(\d{3})+(?!\d))/g, " ")}</b>"

@setPaging = (totalPage = 1) ->
	ret = ''
	unless totalPage is 1
		startPage = curPage < 3 and 1 or curPage is totalPage and curPage - 2 or curPage - 1
		endPage = totalPage - curPage < 2 and totalPage or curPage is 1 and 3 or curPage + 1

		if startPage > 1
			ret += "<li#{curPage is 1 and " class='active'" or ''}><a onclick='paging(this)'>1</a></li>"
			ret += "<li>...</li>" unless startPage is 2
		for i in [startPage..endPage]
			ret += "<li#{curPage is i and " class='active'" or ''}><a onclick='paging(this)'>#{i}</a></li>"
		if endPage < totalPage
			ret += "<li>...</li>" unless endPage is totalPage - 1
			ret += "<li#{curPage is totalPage and " class='active'" or ''}><a onclick='paging(this)'>#{totalPage}</a></li>"

	for ul in document.querySelectorAll '.paging'
		ul.innerHTML = ret

loading = false

loadProducts = ->
	loading = true

	query = []
	for key in ['page', 'show', 'sort', 'min', 'max']
		if val = filterOptions[key]
			query.push key + '=' + val
	options = filterOptions.options
	if options.length
		for id in options
			query.push 'options[]=' + id

	query = query.join '&'
	query = '?' + query if query

	if history and history.pushState
		xhr = new XMLHttpRequest()
		xhr.open 'POST', "/catalog.json"
		xhr.setRequestHeader "Content-Type", "application/json;charset=UTF-8"
		xhr.onload = ->
			ret = ''
			title = "title_#{lang}"
			res = JSON.parse @response
			for p in res.records
				ret += "<li>"
				if record = p.images[0]
					image = record.image
					ret += "<div class='image'>
						<a href=''>
							<img src='#{image.medium.url}' title='#{record.title or ''}' alt='#{record.alt or ''}'>
						</a>
						<a data-rel='lightbox' class='visual-icon' href='#{image.url}' rel='lightbox'></a>
					</div>"
				ret += "<strong class='title'><a href=''>#{p[title]}</a></strong>
					<div class='item-row'>
						<a class='add-cart' href=''>В корзину</a>
						<span class='price' data-price=#{p.retail_price}>#{p.retail_price.productPrice()}</span>
					</div>
				</li>\n"
			products.innerHTML = ret
			setPaging res.totalPage

			sliderPrice res.min, res.max

			$("[rel='lightbox']").fancybox()

			loading = false

		xhr.send JSON.stringify filterOptions

		history.pushState {}, '', query or location.pathname
	else
		location.search = query

@selectChange = (res) ->
	el = res.realElement
	value = el.value
	switch el.id
		when 'sort', 'show'
			if value is 'default'
				delete filterOptions[el.id]
			else filterOptions[el.id] = value
			delete filterOptions.page
			window.curPage = 1
			loadProducts()
		when 'setCurrency'
			split = value.split ','
			window.course = split[0]
			window.currency = split[1]
			document.cookie = "currency_id=#{split[2]}"
			for el in document.querySelectorAll("[data-price]")
				el.innerHTML = (+el.getAttribute("data-price")).productPrice()

@paging = (a) ->
	window.curPage = +a.innerHTML

	if curPage is 1
		delete filterOptions.page
	else filterOptions.page = curPage

	loadProducts()

@sliderPrice = (from, to) ->
	s = $ "#slider_price"
	min = filterOptions.min or from
	max = filterOptions.max or to
	s.slider
		range: true
		min: from
		step: 1
		max: to
		values: [ min, max ]
		slide: ( event, ui ) ->
			$('#price').val ui.values[0].toFixed 0
			$('#price2').val ui.values[1].toFixed 0
		change: ( e, ui ) ->
			unless loading
				min = ui.values[0]
				max = ui.values[1]
				if min is from
					delete filterOptions.min
				else filterOptions.min = min
				if max is to
					delete filterOptions.max
				else filterOptions.max = max
				loadProducts()
	price.value = min
	price2.value = max

@filterChange = (e) ->
	input = e.target
	return unless input.type is 'checkbox'
	if input.checked
		filterOptions.options.push input.value
	else filterOptions.options.splice filterOptions.options.indexOf(input.value), 1
	loadProducts()