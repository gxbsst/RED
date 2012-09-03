	function hideBox(){

document.getElementById("cart").style.height="41px";
document.getElementById("itemsContainer").style.display="none";

document.getElementById("hi_ds").innerHTML='<a  onclick="displayBox()">Show Cart</a>';
	}
	function displayBox(){
document.getElementById("cart").style.height="169px";
document.getElementById("itemsContainer").style.display="block";

document.getElementById("hi_ds").innerHTML='<a  onclick="hideBox()">Hide Cart</a>';

	}
	function removeHideBox(){
		document.getElementById("cart").style.height="0";
document.getElementById("cartTitleText").style.display="none";
document.getElementById("cart").style.	backgroundPosition="right 26px";


	}
	function hideBox1(){
		var isOpera = (window.opera&&navigator.userAgent.match(/opera/gi))?true:false;
var  isIE = (!this.isOpera&&document.all&&navigator.userAgent.match(/msie/gi))?true:false;
var isSafari = (!this.isIE&&navigator.userAgent.match(/safari/gi))?true:false;
var  isGecko = (!this.isIE&&navigator.userAgent.match(/gecko/gi))?true:false;
var isFirefox = (!this.isIE&&navigator.userAgent.match(/firefox/gi))?true:false;

if(isSafari){
document.getElementById("cart").style.backgroundImage="url('http://www.red.com/skin/img/store/safari_cart_bg.png')";

document.getElementById("cart").style.backgroundPosition='right -1px';

}
else{
document.getElementById("cart").style.	backgroundPosition="right 26px";

}

		document.getElementById("cart").style.height="41px";
document.getElementById("itemsContainer").style.display="none";
document.getElementById("textinner").innerHTML='<div id="cartTitle" onclick="displayBox1()"><table id="cartTitleText" width="100%" cellpadding="0" cellspacing="0"><tr ><td class="shoppingcart"><img src="/skin/img/store/shoppinngcart.png" alt="shopping cart" /></td><td  id="indecator1"><div id="indicator" style="display:none;"><img src="/skin/img/store/loading.gif" ></div></td><td  class="money" id="noney"><span>Open this dock to see the contents of your cart</span></td><td class="hidecart" id="hi_ds" ><a  onclick="displayBox1()">Show Cart</a></td></tr></table></div>';
	}

	function displayBox1(){
document.getElementById("cart").style.height="169px";
var z=document.getElementById("cart").scrollHeight;
/*
alert(z);
*/

document.getElementById("cart").style.backgroundImage="url('http://www.red.com/skin/img/store/cart_bg.png')";
document.getElementById("cart").style.backgroundPosition='right bottom';



document.getElementById("itemsContainer").style.display="block";
document.getElementById("textinner").innerHTML='<div id="cartTitle" onclick="hideBox1()"><table id="cartTitleText" width="100%" cellpadding="0" cellspacing="0"><tr ><td class="shoppingcart"><img src="/skin/img/store/shoppinngcart.png" alt="shopping cart" /></td><td  id="indecator1"><div id="indicator" style="display:none;"><img src="/skin/img/store/loading.gif" ></div></td><td  class="money" id="noney"><span>Open this dock to see the contents of your cart</span></td><td class="hidecart" id="hi_ds" ><a  onclick="hideBox1()">Hide Cart</a></td></tr></table></div>';
	}
function displayForemove(){
document.getElementById("cartTitleText").style.display="block";
document.getElementById("cart").style.display="block";
document.getElementById("cart").style.height="169px";
document.getElementById("itemsContainer").style.display="block";
document.getElementById("textinner").innerHTML='<div id="cartTitle" onclick="hideBox1()"><table id="cartTitleText" width="100%" cellpadding="0" cellspacing="0"><tr ><td class="shoppingcart"><img src="/skin/img/store/shoppinngcart.png" alt="shopping cart" /></td><td  id="indecator1"><div id="indicator" style="display:none;"><img src="/skin/img/store/loading.gif" ></div></td><td  class="money" id="noney"><span>This docks shows 	RED product which you ready to buy</span></td><td class="hidecart" id="hi_ds" ><a  onclick="hideBox1()">Hide Cart</a></td></tr></table></div>';
}

function displayCart(){
var z=document.getElementById("cart").scrollHeight;
document.getElementById("cartTitleText").style.display="block";
document.getElementById("cart").style.backgroundImage="url('http://www.red.com/skin/img/store/cart_bg.png')";
document.getElementById("cart").style.backgroundPosition='right bottom';

/*
alert(z);
if(z==137 || z==22 || z==2 || z==200 || z==28 || z==157 || z==176 || z==0 || z==41 || z==46 || z==194)
{
*/
document.getElementById("cart").style.display="block";

document.getElementById("cart").style.height="169px";
document.getElementById("itemsContainer").style.display="block";
document.getElementById("textinner").innerHTML='<div id="cartTitle" onclick="displayBox1()"><table id="cartTitleText" width="100%" cellpadding="0" cellspacing="0"><tr ><td class="shoppingcart"><img src="/skin/img/store/shoppinngcart.png" alt="shopping cart" /></td><td  id="indecator1"><div id="indicator" style="display:none;"><img src="/skin/img/store/loading.gif" ></div></td><td  class="money" id="noney"><span>This docks shows 	RED product which you ready to buy</span></td><td class="hidecart" id="hi_ds" ><a  onclick="displayBox1()">Show Cart</a></td></tr></table></div>';
/*
}
*/
}

  	function htmlBody(){
    		
var isOpera = (window.opera&&navigator.userAgent.match(/opera/gi))?true:false;
var  isIE = (!this.isOpera&&document.all&&navigator.userAgent.match(/msie/gi))?true:false;
var isSafari = (!this.isIE&&navigator.userAgent.match(/safari/gi))?true:false;
var  isGecko = (!this.isIE&&navigator.userAgent.match(/gecko/gi))?true:false;
var isFirefox = (!this.isIE&&navigator.userAgent.match(/firefox/gi))?true:false;

if(isSafari){


var  y= document.scrollHeight;
var z=document.getElementById("cart").scrollHeight;
/*
if(z==184){
document.getElementById("cart").style.backgroundImage="url('http://www.red.com/skin/img/store/cart_bg.png')";

document.getElementById("cart").style.backgroundPosition='right bottom';

}
else{
document.getElementById("cart").style.backgroundImage="url('http://www.red.com/skin/img/store/safari_cart_bg.png')";

document.getElementById("cart").style.backgroundPosition='right -1px';

}
*/
document.body.style.height=y+"px";
																					 

}

else if(isFirefox ||  isOpera){

	var  y= document.getElementById('html').scrollHeight;
document.body.style.height=y+"px";
/*

document.getElementById("cart").style.	backgroundPosition="left 26px";
*/

}
else if(isIE){
	/*
document.getElementById("cart").style.	backgroundPosition="left 26px";
document.getElementById("wrapper1").style.height=document.getElementById("wrapper").scrollHeight+"px";
*/

}
/*var z=document.getElementById("cart").scrollHeight;*/
/*
document.getElementById("cartTitleText").style.display="block";

alert(z);

if(z==158 || z==142){
document.getElementById("hi_ds").innerHTML='<a  onclick="hideBox()">Hide Cart</a>';
}
if(z==137 || z==22 || z==176)
{
	
document.getElementById("hi_ds").innerHTML='<a  onclick="displayBox()">Show Cart</a>';
}

*/

    	}




function moveToPrevious()
{
  new Effect.Move('imageBoxInside', { x: 180, y: 0, transition: Effect.Transitions.sinoidal });
}

function moveToNext()
{
  new Effect.Move('imageBoxInside', { x: -180, y: 0, transition: Effect.Transitions.sinoidal });
}


	
