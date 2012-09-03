function toggleAddress( orderId, src ) {
	var addressPanel = $('addresses_' + orderId);
	// addressPanel.toggle();
	if (addressPanel.style.display == 'none') {
	  new Effect.SlideDown(addressPanel);
	} else {
	  new Effect.SlideUp(addressPanel);
  }
}