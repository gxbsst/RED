function swap_tab2(sex){
  if(sex == "men"){
    document.getElementById('men').className   = "active";
    document.getElementById('women').className = "normal";

  }else{
    document.getElementById('men').className   = "normal";
    document.getElementById('women').className = "active";
  }

  var outer       = document.getElementById('outer');
  var sex_input   = document.getElementById("sex");

  outer.className = sex;
  sex_input.value = sex;
  document.getElementById('product_form').reset();
  if (sex == 'women'){ 
      var size = document.getElementById('size');
        size.className = 'normal';
      }

} 

function selectColor(color){
  var sex_input   = document.getElementById("sex");
  var color_id = document.getElementById(color);
  var value = sex_input.value;
  if (value == 'women'){ 
      var size = document.getElementById('size');
      if (color == 'black') {
        size.className = 'hide_xl';
      } else {
        size.className = 'normal';
      }
      }
    document.getElementById('product_form').reset();
    sex_input.value  = value;
    color_id.checked = true;
}

function get_radio_value(name) {
  var ids = document.getElementsByName(name);
  var value;
  for (var i = 0; i < ids.length; i++) {
    if(ids[i].checked) {
      value = ids[i].value
    }
  }
  return value;
}
/*
function calc_code(sex, color, size) {
  var base = 902000;
  // init weighted
  var weighted  = 0;

  // male: weighted + 0
  // female: weighted + 8
  if (sex == "1") {
    weighted += 8;
  }
  // white: weighted + 0
  // red: weighted + 4
  if (color == "1") {
    weighted += 4;
  } else if(color == "2") {
    if (sex == "1") {
      weighted += 12;
    } else {
      weighted += 16;
    }
  }
  // size range: '1','2','3','4'
  weighted += Number(size);
  return  String(base + weighted);
}

function get_code() {
  var sex = $F('sex');
  var color = get_radio_value('color');
  var size;
  if (sex =="0"){
    size = "man_size";
  }
  else{
    switch(color){
      case "2":
        size = "women_black_size";
      break;
      default:
      size = "women_size";
    }
  }
  return calc_code(sex, get_radio_value('color'), get_radio_value(size));
}

function modify_code(){
  $("code").value = get_code();
  //alert(get_code());
}
*/
