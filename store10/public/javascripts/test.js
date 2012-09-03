var Validator = {
  _massages: [],
 Patterns: {
  email: /^\w[\w.-]+@(\w[\d\w]+)\..+$/i,
  string: /[^/s]+/i, 
  integer: /\d+/i
 }, 
 Check: function( options ){
  var self = this
  self._messages.clear();

  for(var i = 0; i <= options.length; i++ ){
    self._validate(options[i])    
  }

  if(this._massages.length > 0)
  {
    alert(self._magssages.join('\n')) 
    return false;//false => form就不会被post出去...
  }
  else
  {
    return true; //可以继续执行....
  }
 },
 _validate: function(item){
 // Test the reqular expenstion 
 
 }



}
