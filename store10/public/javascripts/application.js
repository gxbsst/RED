// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

/* =====================================================
 * JavaScript Fields Validator
 * 		by Weston, 20th June 2007
 * ------------------------------
 * Usage:	Validator.check([{text:text, pattern:type, message:error_message}, {...}])
 * Return:	Boolean
 * Type:	'email', 'string', 'integer', regex_pattern
 * Require: None
 * =====================================================
 */
var Validator = {
	_messages: [],
	
	Pattern: {
		email: /^([\w\.-]+)@([\w\-]+)(\..+)$/i,
		integer: /\d+/,
		string: /[^\s]+/
	},
	
	check: function(options) {
		var self = this;
		self._messages.clear();
		for (i=0; i<options.length; i++) {
			self._validate(options[i])
		}
		if (this._messages.length > 0) {
			alert(this._messages.join('\n'));
			return false;
		} else {
			return true;
		}
	},
	
	_validate: function(item) {
		if (typeof(item.pattern) == 'string') {
			return this._validateWithRegEx(item.text, eval('this.Pattern.' + item.pattern), item.message);
		} else {
			return this._validateWithRegEx(item.text, item.pattern, item.message);
		}
	},
	
	_validateWithRegEx: function(text, regex, message) {
		if (regex.test(text) == false) {
			this._messages.push(message);
			return false;
		} else {
			return true;
		}
	}
}

/* ===========================
 * Switch Interface Language
 * ===========================
 */
function switchLanguage(value) {
  var currentLanguage = '';
  var relativePath = '';
  
  path = location.pathname.split('/');
  if (path.length >= 2 && /[a-z]{2}_[A-Z]{2}/.test(path[1]) ) {
    currentLanguage = path[1];
    relativePath = '/' + path.slice(2).join('/');
  } else {
    currentLanguage = 'en_US';
    relativePath = location.pathname;
  }

  if (value == currentLanguage)
    return false;
  else {
    newPath = '/' + value + relativePath;
    location.pathname = newPath;
  }
}

var RED = {}

RED.Navigator = {
	currentTab: null,
	
	subNavigatorId: function(elementId) {
		return 'navigator-' + elementId;
	},
	
	selectTab: function(elementId) {
		this.closeTab();
		var element = this.subNavigatorId(elementId);
		$(element).style.display = 'block';
		this.currentTab = element;
	},
	
	closeTab: function() {
		if (this.currentTab) {
			$(this.currentTab).style.display = 'none';
			this.currentTab = null;
		}
	},
	
	eventObserver: function(event) {
		var element = Event.findElement(event, 'li');
		if (!element || !element.id) {
			this.closeTab()
		} else if (element.id == 'cameras' || element.id == 'accessories') {
			this.selectTab(element.id)
		}
	},
	
	attachObserver: function() {
		var self = this;
		$('navigator').onmouseover = function(event) {
			self.eventObserver(event);
		}
	},
	
	initStatus: function(elementId) {
		this.attachObserver();
		if (elementId) {
			this.selectTab(elementId);
		}
	}
}
