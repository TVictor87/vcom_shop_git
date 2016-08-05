form = document.forms[1]
token = form.authenticity_token.value
array_slice = [].slice
currentCancel = null

slice = (arg) -> array_slice.call arg

toColor = (el) ->
	value = el.innerHTML
	el.innerHTML = "<div style='display:inline-block;vertical-align:middle;margin:0 10px;width: 30px;height: 20px;background: ##{value.substr 0, 6}'></div>#{value.substr 6}"

colorValue = (value) -> "<div style='display:inline-block;vertical-align:middle;margin:0 10px;width: 30px;height: 20px;background: ##{value.substr 0, 6}'></div>#{value.substr 6}"


saveRow = (method, url, params = {}, cb) ->
	tr = @parentNode.parentNode
	ch = tr.children
	count = ch.length
	ids = []
	option_tds = []
	for i in [0..count - 4]
		td = ch[i]
		option_tds[i] = td
		id = +td.firstChild.firstElementChild.value
		return alert 'Выберите опцию' unless id
		ids[i] = id
	quantity_td = ch[count - 3]
	price_td = ch[count - 2]
	quantity = +quantity_td.firstChild.value
	price = +price_td.firstChild.value
	xhr = new XMLHttpRequest()
	xhr.open method, url
	xhr.setRequestHeader "Content-Type", "application/json;charset=UTF-8"
	next = @nextElementSibling
	xhr.onload = ->
		switch @status
			when 200
				for td, i in option_tds
					td.dataset.id = ids[i]
				quantity_td.dataset.value = quantity
				price_td.dataset.value = price
				WarehouseTable.cancel.call next
				cb @response if cb
			when 422
				alert "Такой набор опций уже есть"
			else
				alert "Ошибка"
	params.authenticity_token = token
	params.option_ids = ids
	params.quantity = quantity
	params.retail_price_changed = price
	xhr.send JSON.stringify params

addSelect = (td, th) ->
	select = window["option_group_select_#{th.dataset.id}"]
	select.style.display = 'block'
	span = select.children[1]
	current = span.children[0].children[0].children[0]
	current.title = ''
	isColor = th.dataset.type is 'color'
	list = select.children[0]
	if id = td.dataset.id
		list.value = "#{id}"
		value = list.querySelector("[value='#{id}']").innerHTML
		current.innerHTML = isColor and colorValue(value) or value
	else
		list.value = ''
		current.innerHTML = ''
	if isColor and not select.listenersAdded
		select.listenersAdded = true
		$(list).on 'select2:select', (e) ->
			toColor e.target.nextElementSibling.firstChild.firstChild.firstChild
		span.addEventListener 'click', (event) ->
			if ul = document.querySelector '.select2-results__options'
				options = ul.children
				toColor option for option in slice options
				parent = ul.parentNode
				input = parent.previousElementSibling.firstChild
				unless input.listenersAdded
					input.listenersAdded = true
					input.addEventListener 'input', ->
						toColor option for option in slice options
	td.appendChild select

@WarehouseTable =
	delete: ->
		if confirm "Удалить запись?"
			tr = $(@).parents 'tr'
			xhr = new XMLHttpRequest()
			xhr.open 'DELETE', "/admin/warehouse_products/#{tr.data 'id'}"
			xhr.setRequestHeader "Content-Type", "application/json;charset=UTF-8"
			xhr.onload = ->
				if @status is 200
					t = tr.parents('table').DataTable()
					t.row(tr).remove().draw()
			xhr.send JSON.stringify authenticity_token: token
	edit: ->
		WarehouseTable.cancel.call currentCancel if currentCancel
		currentCancel = @nextElementSibling
		@className = 'btn btn-success'
		@children[0].className = 'fa fa-check-square-o'
		@onclick = WarehouseTable.update
		currentCancel.className = 'btn btn-info'
		currentCancel.children[0].className = 'fa fa-times-circle-o'
		currentCancel.onclick = WarehouseTable.cancel
		tr = @parentNode.parentNode
		ths = tr.parentNode.previousElementSibling.children[0].children
		ch = tr.children
		count = ch.length
		for i in [0..count - 4]
			td = ch[i]
			td.removeChild c while c = td.firstChild
			addSelect td, ths[i]
		for i in [count - 3..count - 2]
			td = ch[i]
			value = td.innerHTML
			td.dataset.value = value
			td.innerHTML = "<input class='string optional form-control' value='#{value}'>"
	cancel: ->
		currentCancel = null
		prev = @previousElementSibling
		prev.className = 'btn btn-warning'
		prev.children[0].className = 'fa fa-pencil-square-o'
		prev.onclick = WarehouseTable.edit
		@className = 'btn btn-danger'
		@children[0].className = 'fa fa-trash-o'
		@onclick = WarehouseTable.delete
		tr = @parentNode.parentNode
		ch = tr.children
		ths = tr.parentNode.previousElementSibling.children[0].children
		count = ch.length
		for i in [0..count - 4]
			td = ch[i]
			th = ths[i]
			select = td.firstChild
			select.style.display = 'none'
			form.appendChild select
			id = td.dataset.id
			value = select.children[0].querySelector("[value='#{id}']").innerHTML
			td.innerHTML = th.dataset.type is 'color' and colorValue(value) or value
		for i in [count - 3..count - 2]
			td = ch[i]
			td.innerHTML = td.dataset.value
	update: ->
		tr = @parentNode.parentNode
		ch = tr.children
		count = ch.length
		ids = []
		option_tds = []
		for i in [0..count - 4]
			td = ch[i]
			option_tds[i] = td
			ids[i] = +td.firstChild.firstElementChild.value
		quantity_td = ch[count - 3]
		price_td = ch[count - 2]
		quantity = +quantity_td.firstChild.value
		price = +price_td.firstChild.value
		xhr = new XMLHttpRequest()
		xhr.open 'PUT', "/admin/warehouse_products/#{tr.dataset.id}"
		xhr.setRequestHeader "Content-Type", "application/json;charset=UTF-8"
		next = @nextElementSibling
		xhr.onload = ->
			switch @status
				when 200
					for td, i in option_tds
						td.dataset.id = ids[i]
					quantity_td.dataset.value = quantity
					price_td.dataset.value = price
					WarehouseTable.cancel.call next
				when 422
					alert "Такой набор опций уже есть"
				else
					alert "Ошибка"
		xhr.send JSON.stringify authenticity_token: token, option_ids: ids, quantity: quantity, retail_price_changed: price
	cancelAdd: ->
		tr = @parentNode.parentNode
		tr.parentNode.removeChild tr
	add: ->
		t = @nextElementSibling.children[1].firstChild
		head = t.firstElementChild.firstElementChild
		options = head.childElementCount - 4
		row = ''
		row += "<td></td>" for i in [0..options]
		row += "<td><input class='string optional form-control' value='0'></td>" for [1..2]
		row += '<td style="white-space:nowrap">
			<div class="btn btn-success" onclick="WarehouseTable.create.call(this, ' + @dataset.warehouseId + ')">
				<div class="fa fa-check-square-o"></div>
			</div>
			<div class="btn btn-info" onclick="WarehouseTable.cancelAdd.call(this)">
				<div class="fa fa-times-circle-o"></div>
			</div>
		</td>'
		b = t.children[1]
		b.insertAdjacentHTML 'afterBegin', row
		tr = b.firstChild
		ch = tr.children
		ths = head.children
		addSelect ch[i], ths[i] for i in [0..options]
	create: (warehouse_id) ->
		el = @
		saveRow.call @, 'POST', '/admin/warehouse_products', product_id: product_id, warehouse_id: warehouse_id, (id) ->
			tr = el.parentNode.parentNode
			b = tr.parentNode
			row = []
			ch = tr.children
			for td in slice ch
				row.push td.innerHTML
			b.removeChild tr
			tr = $(b.parentNode).DataTable().row.add(row).draw().node()
			tr.dataset.id = +id
			l = ch.length
			ch[l - i].dataset.value = +ch.innerHTML for i in [2..3]