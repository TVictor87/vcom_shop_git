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
#= require jquery
#= require jquery_ujs
#= require jquery-ui.min
#= require plugins/rails.validations.simple_form.bootstrap.coffee
#= require admin/AdminLTE/admin-lte
#= require_tree .

@addOption = (el, group_id, active) ->
	trs = el.parentElement.getElementsByTagName('tr')
	trs[trs.length - 1].insertAdjacentHTML 'afterEnd', "<tr>
		<input type='hidden' name='new_option[][option_group_id]' value='#{group_id}'>
		<td><input type='text' class='form-control' name='new_option[][priority]'></td>
		<td><input value='1' type='text' class='form-control' name='new_option[][column]'></td>
		<td><input type='text' class='form-control' name='new_option[][value]'></td>
		#{if active
			"<td><input type='text' class='form-control' name='new_option[][retail_price]'></td>
			<td>
				<div class='form-group select optional'>
					<select class='select optional select2 form-control' name='new_option[][retail_price_currency_id]'>
						#{
							selected = true
							currencies.reduce ((res, c) -> res + "<option#{if selected then selected = false; " selected='selected'" else ''} value='#{c.id}'>#{c["title_#{locale}"]}</option>" ), ''
						}
					</select>
				</div>
			</td>"
		else ''}
		<td>
			<div onclick='removeOption(this)' class='btn btn-danger'>Удалить</div>
		</td>
	</tr>"

@removeOption = (el) ->
	tr = el.parentNode.parentNode
	tr.parentNode.removeChild tr