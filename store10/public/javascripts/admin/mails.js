function mailFromChanged( source ) {
  var element = $(source);
  if ( element.tagName.toLowerCase() == 'select' && element.value == '_customize_' )
    var toggleElement = element.nextSibling
  else if ( element.tagName.toLowerCase() == 'input' && element.value == '' )
    var toggleElement = element.previousSibling
  else
    return false;
  
  with ( element ) {
    hide(); disabled = true;
    toggleElement.disabled = false; toggleElement.show(); toggleElement.value = '';
  }
}

// Set "From" field of this task.
function setMailFrom( from ) {
  var select = $$('select#task_from')[0], input = $$('input#task_from')[0];
  input.value = from;
  
  select.hide(); select.disabled = true;
  input.show(); input.disabled = false;
}

// Update recipients list
function returnRecipients() {
  $('recipients_wrapper').innerHTML = window.top.recipientsHTML;
  window.top.recipientsHTML = null;
}

// Append additional condition as recipients filter
function appendCondition() {
  var conditions = document.getElementsByClassName('conditions');
  var form = $('recipients_conditions_form');
  var maxConditionIndex = parseInt( form.getAttribute('_conditions') );
  var nextIndex = ( maxConditionIndex + 1 ).toString();
  
  // Generate condition wrapper
  var wrapper = document.createElement('div');
  wrapper.setAttribute( 'class', 'conditions' );
  wrapper.setAttribute( 'id', 'conditions_' + nextIndex );
  
  // Copy condition fields
  var html = conditions[0].innerHTML;
  wrapper.innerHTML = html.replace( /(conditions\[)(\])/g, '$1' + nextIndex + '$2' );
  
  // Update form attribute
  form.setAttribute( '_conditions', nextIndex );
  
  // Insert node
  $('conditions_wrapper').appendChild(wrapper);
  wrapper = null;
}

function queryForRecipients ( closeWin ) {
	new Ajax.Updater( 'select_recipients_wrapper', $('recipients_conditions_form').action, {
		asynchronous:true,
		evalScripts:true,
		onComplete: function ( request ) {
			new Effect.Appear('select_recipients_wrapper')
		},
		onLoading: function ( request ) {
			new Effect.Fade( 'select_recipients_wrapper', { to: 0.4 } )
		},
		onSuccess: function ( request ) {
			window.top.recipientsHTML= request.responseText
			if ( closeWin ) {
				window.top.hidePopWin(true)
			}
		},
		parameters: Form.serialize('recipients_conditions_form')
	} )
}

// Event Observer for mail preview
function previewObserver( event ) {
  var element = Event.findElement( event, 'tr' );
  if ( !element || !( recipientId = element.getAttribute('rel') ) )
    return false;

  with( $('edit_task') ) {
    var originalAction = action;
    target = "_blank"; action = "/admin/mails/preview/" + recipientId.toString();
    submit();
    action = originalAction; target = "";
  }
}

// Event Observer for picking up a template
function templateObserver( event ) {
  var element = Event.findElement( event, 'input' );
  if (!element) return false;
	window.location = element.getAttribute('rel');
}

// Binding event observers
try {
  Event.observe( 'recipients_wrapper', 'click', previewObserver ); // click on the recipients list for preview
  Event.observe( 'templates', 'click', templateObserver ); // pick up a template will fill in the task info
} catch (exception) {
  // do nothing
}