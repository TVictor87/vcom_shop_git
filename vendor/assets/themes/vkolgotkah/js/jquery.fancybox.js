/* Fancybox overlay fix */
jQuery(function(){
	// detect device type
	var isTouchDevice = (function() {
		try {
			return ('ontouchstart' in window) || window.DocumentTouch && document instanceof DocumentTouch;
		} catch (e) {
			return false;
		}
	}());

	// fix options
    var supportPositionFixed = true;
	//var supportPositionFixed = !( ($.browser.msie && $.browser.version < 8) || isTouchDevice );
	var overlaySelector = '#fancybox-overlay';

	if(supportPositionFixed) {
		// create <style> rules
		var head = document.getElementsByTagName('head')[0],
			style = document.createElement('style'),
			rules = document.createTextNode(overlaySelector+'{'+
				'position:fixed;'+
				'top:0;'+
				'left:0;'+
			'}');

		// append style element
		style.type = 'text/css';
		if(style.styleSheet) {
			style.styleSheet.cssText = rules.nodeValue;
		} else {
			style.appendChild(rules);
		}
		head.appendChild(style);
	}
});