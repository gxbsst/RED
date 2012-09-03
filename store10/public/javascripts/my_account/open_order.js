var OpenOrder = {
	// salesLines: [],
	openOrders: [],
	draggingElement: null,
	
	init: function() {
		var self = this;
		this.openOrders = document.getElementsByClassName('open_order_lines');
		
		this.initSortables();
		this.openOrders.each(function(element, index) {
			self.initInPlaceEditor(element);
		});
		
		// Append observer
		Draggables.addObserver(OpenOrderObserver);
	},
	
	// Delete the specified sales line
	deleteSalesLine: function(salesLineId) {
		var elementId = "open_order_line_" + salesLineId.toString();
		new Ajax.Request(
			"delete_sales_line/" + salesLineId.toString(), {
				onSuccess: function() {
					new Effect.DropOut(elementId, { duration: 1 });
					setTimeout(function() {
						OpenOrder.refreshOrder($(elementId).getAttribute('order'));
					}, 1000)
				}
			}
		);
	},
	
	// Refresh an order with given id
	refreshOrder: function(orderId) {
		new Ajax.Updater(
			"order_wrapper_" + orderId,
			"refresh_order/" + orderId,
			{
				onLoading: function() {
					$("order_wrapper_" + orderId).innerHTML = "Loading...";
				},
				onComplete: function() {
					OpenOrder.initSortables();
					OpenOrder.initInPlaceEditor("open_order_lines_" + orderId);
					$("save_change_button").removeAttribute("disabled");
				}
			}
		)
	},
	
	initSortables: function() {
		orders = 	document.getElementsByClassName("open_order_lines");
		orders.each(function(element, index) {
			Sortable.create(element, { handle: "drag_handle", containment: orders, only: "draggable" });
		})
	},
	
	initInPlaceEditor: function(order) {
		document.getElementsByClassName('edit_qty', order).each(function(element, index) {
			new Ajax.InPlaceEditor(element, "update_sales_line_qty/" + element.getAttribute("rel"), {
				size: 2,
				okText: "",
				cancelLink: false,
				onFailure: function(transport) {},
				ajaxOptions: {
					onSuccess: function() { OpenOrder.refreshOrder(element.getAttribute("order_id")); }
				}
			})
		});
	},
	
	refreshOrders: function(orderIds) {
	  var self = this;
	  orderIds.each( function(orderId) {
	    self.refreshOrder(orderId);
	  });
	}
}

var OpenOrderObserver = {
	onEnd: function(eventName, draggable, event) {
	  var element = draggable.element;
	  var targetOrderId = element.parentNode.getAttribute("id").split("_").last();
	  
	  if (element.getAttribute("order") == targetOrderId) {
	    return false;
	  }
	  
	  new Ajax.Request("move_sales_line/" + element.id.split("_").last(), {
	    parameters: "target=" + targetOrderId
	  });
	}
}

document.body.onload = OpenOrder.init();

/*
	Select an existing address from customer's address book, post it's id to remote
	  and then fill in current editing form.
	PLEASE DO NOT FORGET TO CLICK THE "UPDATE" BUTTON FOR SAVING CHANGES!!
*/
function fillInAddressForm( form_id, address_id ) {
  if (address_id == '')
    return false;
  
	var address_form = $(form_id);
	new Ajax.Request('get_address_json/' + address_id, {
	  onLoading: function() {
	    address_form.commit.disabled = true;
	  },
		onSuccess: function( transport, json ) {
			eval("var address = " + transport.responseText);
			address_form.address_country.value = address.country_region_id;
			address_form.address_state.value = address.state;
			address_form.address_street.value = address.street;
			address_form.address_city.value = address.city;
			address_form.address_zip_code.value = address.zip_code;
		},
		onComplete: function() {
		  address_form.commit.disabled = false;
		}
	})
}

/* Ajax Transport Error */
function transportError() {
  var op = confirm('Unfortunately, there seems to be something unexpected.\n\nClick "OK" to reload this page or "Cancel" to ignore.');
  if (op) document.location.reload();
}