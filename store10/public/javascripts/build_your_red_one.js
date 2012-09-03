/*
* JavaScript for feature "Build Your RED ONE"
* TODO: Generate an object named "Cart" to store all the products information
*   on this page, also provides methods to calculate total price.
* REQUIRE: Prototype JS Library (1.5.x)
*/

function toggleDescPanel (panelId) {
	var panel = $("descPanel_" + panelId);
	if (panel.style.display == "none")
		new Effect.BlindDown(panel, { duration: 0.5 })
	else
		new Effect.BlindUp(panel, { duration: 0.5 });
}

function showHowToAssemble(element) {
	return hs.expand(element);
}

// Toggle sub package panel.
// While closing a panel, reset the quantity to "0" preventing posting there data
//   to server (because they are NOT SELETED if you do not select their parent node).
function toggleSubPackagePanel(element) {
	var parentPackage = $(element.name);
	var currentPackage = parentPackage.getAttribute("_currentPackage");
	
	if (currentPackage == element.value) return false; // Do nothing and return if this package is alerady selected.
	
	if (currentPackage!=null) {
		new Effect.BlindUp(currentPackage);
		var sub_products = document.getElementsByClassName("product_in_package", currentPackage);
		
		// Reset quantity to zero in the previous package user selected.
		for (i=0; i<sub_products.length; i++) {
			sub_products[i].value = 0;
		}
	}
	
	parentPackage.setAttribute("_currentPackage", element.value);
	new Effect.BlindDown(element.value);
}

// Parsing a number to currency format.
function parseCurrency(integer) {
	var ary = integer.toString().split("."), str = ary[0], result = "";
	
	for (i=0; i<str.length; i++) {
		result += str.charAt(i);
		if ((str.length - i - 1) % 3 == 0 && i < str.length - 1) result += ","
	}
	
	if (ary.length > 1) result += "." + ary[1];
	return "$" + result;
}

var Cart = {
	// Items Collection.
	// Key: Product Id; Value: JSON contains product id, quantity and price.
	items: $H(),
	
	// Convert an node to JSON
	convertNode: function(node) {
		return {
			"productId": parseInt(node.getAttribute("productId")),
			"quantity": (node.tagName.toLowerCase() == "select" ? parseInt(node.value) : (node.checked ? 1 : 0)),
			"price": parseInt(node.getAttribute("price"))
		}
	},
	
	// Any changes should fire this function.
	// To change/remove an item line from cart, and then refresh the total price.
	change: function(node) {
		var item = this.convertNode(node);
		this.items[item.productId] = item;
		this.onchange(item, node); // Fire the callback method.
	},
	
	// Sum the total of all products in current cart.
	sum: function() {
		var total = 0;
		this.items.each(function (pair) {
			total += pair.value.quantity * pair.value.price;
		});
		return total;
	},
	
	// Initialize cart after page loaded.
	// Note:
	//   Default items are saved to "Cart.defaultItems" as Hash.
	initialize: function() {
		this.items = this.items.merge(this.defaultItems);
		
		var self = this, nodes = $A(document.getElementsByTagName("input")).concat($A(document.getElementsByTagName("select")));
		nodes.each(function(node) {
			if (node.getAttribute("productId")) {
				var product = self.convertNode(node);
				if (product.quantity > 0) {
					self.change(node);
				}
			}
		});
	},
	
	/* Callback Methods */
	
	/* This method will be fired after calling "change" method.
	 * Parameter "item" returns an JSON object contains product id,
	 *   quantity and price.
	 * Usage:
	 *   Cart.onchange = function(item) { alert(item.quantity + "x" + item.price); }
	*/
	onchange: function(item, node) {
		alert(item.toString());
	}
}


Cart.onchange = function(item, node) {
	// Update the price cell if exists.
	var priceCell = $("subtotal_" + item.productId);
	if (priceCell) {
		priceCell.innerHTML = (item.quantity == 0 ? "" : item.quantity + " x ") + parseCurrency(item.price);
	}
	
	// Update price cell of a secondary-level package.
	var package = $(node.getAttribute("parent"));
	if (package.tagName.toLowerCase() == "tr") {

		// Initialize container of sub-package.
		if (!package.items) {
			package.items = $H();
		}
		
		// Calculate subtotal of this sub-package.
		package.items[item.productId] = item;
		var subtotal = 0;
		package.items.values().each(function(o) {
			subtotal += o.quantity * o.price;
		});
		package.getElementsByTagName('td')[0].innerHTML = parseCurrency(subtotal);
		// dont use childNodes  -->  package.childNodes[3].innerHTML = parseCurrency(subtotal);
		
		if (subtotal > 0) {
			$("radio_" + package.id).click();
		}
	}
	
	// Highlight the selected products.
	var highlight = $(node.getAttribute("highlight"));
	if (highlight) {
		if (item.quantity == 0)
			highlight.removeClassName("selected")
		else
			highlight.addClassName("selected");
	}
	
	// Update the total of this configuration list.
	$("total").innerHTML = "SUBTOTAL: " + parseCurrency(this.sum());
}

function clickRadio(element) {
	var parentPackage = $(element.getAttribute("parent"));
	
	var checkedItem = parentPackage.checkedItem;
	if (checkedItem == element) return false; // Do nothing if click on the selected item.
	
	// Un-select the previous package/product.
	if (checkedItem) {
		var subPackagePanel = $("sub_" + checkedItem.name);
		if (subPackagePanel) new Effect.BlindUp(subPackagePanel, { duration: 0.5 });
		
		// Reset quantity to 0
		var package = $(checkedItem.name);
		if (package.items) {
			package.items.values().each(function(item) {
				var element = $("selected[" + item.productId + "]");
				element.value = 0;
				Cart.change(element);
			});
		}
		checkedItem.checked = false;
		
		// Remove previous selected product from cart.
		if (checkedItem.getAttribute("productId")) Cart.change(checkedItem);
	}
	
	// Select current package/product.
	var packagePanel = $("sub_" + element.name);
	if (packagePanel) new Effect.BlindDown(packagePanel, { duration: 0.5});
	parentPackage.checkedItem = element;
	
	// Add this product to cart.
	if (element.getAttribute("productId")) Cart.change(element);
}

window.onload = function() { 
  // Initialize the shopping cart items.
  Cart.initialize();
  
  // BUG FIX:
  //   Initialize selected radios to prevent "double select".
  var inputs = document.getElementsByTagName("input");
  for (i = 0; i < inputs.length; i++) {
    var element = inputs[i];
    if (element.type == "radio" && element.checked) {
      var parentPackage = document.getElementById(element.getAttribute("parent"));
      parentPackage.checkedItem = element;
    }
  }
};