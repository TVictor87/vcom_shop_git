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

loadProducts = ->
	query = ''
	if filterOptions.pageNumber
		query += 'page=' + filterOptions.pageNumber
	if filterOptions.show
		query += '&' if query
		query += 'show=' + filterOptions.show
	if filterOptions.sort
		query += '&' if query
		query += 'sort=' + filterOptions.sort
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
					ret += "<a data-rel='lightbox' class='visual-link' href='#{image.url}' rel='lightbox'>
						<img src='#{image.medium.url}' title='#{record.title}' alt='#{record.alt}'>
					</a>"
				ret += "<strong class='title'><a href=''>#{p[title]}</a></strong>
					<div class='item-row'>
						<a class='add-cart' href=''>В корзину</a>
						<span class='price'><strong>#{p.retail_price.toCurrency()}</strong> грн</span>
					</div>
				</li>\n"
			products.innerHTML = ret
			setPaging res.totalPage

		xhr.send JSON.stringify filterOptions

		history.pushState {}, '', query or location.pathname
	else
		location.search = query

@filter = (res) ->
	el = res.realElement
	value = el.value
	if value is 'default'
		delete filterOptions[el.id]
	else filterOptions[el.id] = value
	delete filterOptions.pageNumber
	window.curPage = 1

	loadProducts()

@paging = (a) ->
	window.curPage = +a.innerHTML

	if curPage is 1
		delete filterOptions.pageNumber
	else filterOptions.pageNumber = curPage

	loadProducts()