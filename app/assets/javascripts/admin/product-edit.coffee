@WarehouseTable =
	delete: (el) ->
		if confirm "Удалить запись?"
			window.el = el
			tr = $(el).parents 'tr'
			xhr = new XMLHttpRequest()
			xhr.open 'DELETE', "/admin/warehouse_products/#{tr.data 'id'}"
			xhr.setRequestHeader "Content-Type", "application/json;charset=UTF-8"
			xhr.onload = ->
				if @status is 200
					t = tr.parents('table').dataTable()
					t.fnDeleteRow t.fnGetData(tr)[0] - 1
			xhr.send JSON.stringify authenticity_token: document.forms[1].authenticity_token.value
	edit: (el) ->
		console.log 'edit', el