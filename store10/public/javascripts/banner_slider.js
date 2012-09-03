	/*
  Syntax is the following:
  new CrossFader('id1', 'id2', 'id3', 'id4);
  Where id1, id2, etc are ids of elements with children elements that have a class name of "text" and "image"
  where image will show first, then text overlays.
  Default container is #crossfade
*/

var CrossFader = Class.create();
CrossFader.prototype = {
  // settings
  interval: 5, // interval for changing crossfader (in seconds)
  
  items: [],
  currentItemIndex: 0,
  currentItem:null,
  timer: null,
  
  
  initialize: function(){
    this.container = $('crossfade');
    this.container.style.visibility = 'visible';
    
    for (var i=0, arg; arg = arguments[i]; i++){
      var item = $(arg);
      this.container.appendChild(item.remove());
      this.items.push({
        image: item.down('.image').hide(),
        text: item.down('.text').hide()
      });
    }
    
    // on init, show first one
    this.reveal(this.items[0]);
    
    // then set up an interval
    setInterval(this.poll.bind(this), this.interval*1000);
  },
  
  // timer function
  poll: function(){
    // reset to beginning if at end
    if (++this.currentItemIndex >= this.items.length) this.currentItemIndex = 0;
    this.reveal(this.items[this.currentItemIndex]);
  },
  
  reveal: function(item){
    // before revealing, we must hide if applicable
    if (this.currentItem){ this.hide(item); return }
    
    var show_text = function(){ 
      new Effect.Appear(item.text);
    }
    item.image.style.zIndex = 2;
    new Effect.Appear(item.image, {afterFinish:show_text});
        
    this.currentItem = item;
  },
  
  hide: function(itemToShow){
    var after_finish = function(){
      this.currentItem.image.style.zIndex = 1;
      new Effect.Fade(this.currentItem.image);
      this.currentItem = null;
      this.reveal(itemToShow);
    }.bind(this);
    
    new Effect.Fade(this.currentItem.text, {afterFinish: after_finish, duration:0.5});
  }
}

//mini slider
//mini slider
var n=0;
function Mea(value){
  n=value;
  var out_box="au";
  var outer ="outer";
  setBg(value);
  plays(value,out_box,outer);
  }

function setBg(value){
for(var i=0;i<6;i++){
document.getElementById("t"+i+"").className="";
document.getElementById("t"+value+"").className="active";
}
}

function plays(value,out_box,outer){
    try
    {
        with (out_box){
            filters[0].Apply();
            for(i=0;i<6;i++)i==value?children[i].style.display="block":children[i].style.display="none";
            filters[0].play();
        }
    }
    catch(e)
    {
        var d = document.getElementsByClassName(outer);
        //alert(d);
        for(i=0;i<6;i++)i==value?d[i].style.display="block":d[i].style.display="none";
    }
}
function clearAuto(){
  clearInterval(autoStart);autoStart=null;
}
function setAuto(){
  autoStart=setInterval("auto(n)", 3000)
}
function auto(){
    n++;
    if(n>5)n=0;
    Mea(n);
}
function setPause(){
    if(autoStart==null){
        setAuto();
        document.getElementById('pause').firstChild.src="/skin/img/index/pause.gif";
    }
    else{
        clearAuto();
        document.getElementById('pause').firstChild.src="/skin/img/index/play.jpg";
    }
}
	/*
 Banner Slider
 Requirement: prototype.js, effect.js

var BannerSlider = {
 initialize: function(wrapperId, delay, animationDuration) {
   this.sliderWrapper = $(wrapperId);
   this.delay = delay;
   this.animationDuration = animationDuration;
   this.sliderWrapper.cleanWhitespace();
   new Effect.Appear(this.sliderWrapper.childNodes[0],{duration: this.animationDuration});
   new Effect.Appear(this.sliderWrapper.childNodes[0].childNodes[1],{duration: this.animationDuration,delay: 2});
 },
 
 start: function() {
   window.BannerSliderInterval = setInterval('BannerSlider.playAnimation()', this.delay + 2000);
 },
 
 playAnimation: function() {
   this.fadeItem(this.sliderWrapper.childNodes[0]);
   this.showItem(this.sliderWrapper.childNodes[1]);
   setTimeout('BannerSlider.moveNext()',this.delay);
 },
 
 moveNext: function() {
   this.sliderWrapper.appendChild(this.sliderWrapper.childNodes[0]);
 },
 
 fadeItem: function(element) {
   new Effect.Fade(element, { duration: 2 });
   new Effect.Fade(element.childNodes[1], { duration: 2 });
 },
 
 showItem: function(element) {
   new Effect.Appear(element, { duration: this.animationDuration});
   new Effect.Appear(element.childNodes[1],{duraltion: this.animationDuration,delay: 2});
 },
 
 stop: function() {
   clearInterval(window.BannerSliderInterval);
 }
}
*/
