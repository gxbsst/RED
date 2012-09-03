/*
 +-------------------------------------------------------------------+
 |                  J S - C H E C K F O R M   (v1.3)                 |
 |                                                                   |
 | Copyright Gerd Tentler               www.gerd-tentler.de/tools    |
 | Created: Oct. 23, 2001               Last modified: Jun. 17, 2006 |
 +-------------------------------------------------------------------+
 | This program may be used and hosted free of charge by anyone for  |
 | personal purpose as long as this copyright notice remains intact. |
 |                                                                   |
 | Obtain permission before selling the code for this program or     |
 | hosting this software on a commercial website or redistributing   |
 | this software over the Internet or in any other medium. In all    |
 | cases copyright must remain intact.                               |
 +-------------------------------------------------------------------+

======================================================================================================

 ARGUMENTS:

  - form-name or -number
  - 'field:title:type:minimum length'[, ...]  (type = number / mail / url / date(format) / [none])

 Example:

 checkForm('frm1', 'name:::2', 'age::number:1', 'eMail:e-mail:mail:1', 'homepage::url:0',
           'birthday::date(dmy):1');

------------------------------------------------------------------------------------------------------
 This script was tested with the following systems and browsers:

 - Windows XP: IE 6, NN 7, Opera 7, Firefox 1
 - Mac OS X:   IE 5, Safari 1

 If you use another browser or system, this script may not work for you - sorry.

 NOTE: Safari 1 on Mac OS X does only accept dates between Jan. 1, 1901 and Dec. 31, 2037 as valid.
======================================================================================================
*/
//--------------------------------------------------------------------------------------------------------
// Language settings
//--------------------------------------------------------------------------------------------------------

var msgNumber  = "must be a number";
var msgEMail   = "must be an e-mail address";
var msgURL     = "must be a web address";
var msgDate    = "must be a date";
var msgFillOut = "Please fill out";
var msgNoForm  = "Form does not exist";
var msgNoField = "Field does not exist";

//--------------------------------------------------------------------------------------------------------
// Functions
//--------------------------------------------------------------------------------------------------------

function _trim(str) {
  if(str) {
    str = str.replace(/^\s+/, "");
    str = str.replace(/\s+$/, "");
  }
  return str;
}

function _isDate(year, month, day) {
  month--;
  if(year < 100) year += 2000;
  var d = new Date(year, month, day);
  return ((day == d.getDate()) && (month == d.getMonth()) && (year == d.getFullYear()));
}

function checkForm() {
  var args = checkForm.arguments;
  var f = args[0];
  var msg = "";
  var arr, field, title, type, minLength, elem, val, cnt, nr, i, j;
  var format, d, day, month, year;

  var valid_url = /^(https?|ftp):\/\/([a-z0-9._-]+:[a-z0-9._-]+@)?[a-z0-9äöüÄÖÜ#._\/~% -]+(\?([a-z0-9_-]+(=[a-zA-Z0-99äöüÄÖÜß+%?_-]+&?)?)*)?$/i;
  var valid_mail = /^[a-z0-9._-]+@[a-z0-9äöüÄÖÜ.-]+\.[a-z]{2,4}$/i;

  if(document.forms[f]) {
    for(i = 1; i < args.length; i++) {
      arr = args[i].split(":");
      field = _trim(arr[0]);
      title = _trim(arr[1]);
      if(!title) title = field;
      type = _trim(arr[2].toLowerCase());
      minLength = _trim(arr[3]);
      elem = document.forms[f].elements[field];

      if(elem) {
        val = _trim(elem.value);

        if(val != "") {
          if(type == "number") {
            val = val.replace(",", ".");
            if(isNaN(val)) msg += '"' + title + '" ' + msgNumber + "\n";
          }
          else if(type == "mail" && val.search(valid_mail) == -1) msg += '"' + title + '" ' + msgEMail + "\n";
          else if(type == "url" && val.search(valid_url) == -1) msg += '"' + title + '" ' + msgURL + "\n";
          else if(type.indexOf("date") != -1) {
            if(type.indexOf("(") != -1) format = type.substr(type.indexOf("("));
            else format = "(dmy)";
            d = val;

            for(j = 1; j < format.length - 1; j++) {
              cnt = d.search(/[^0-9]/);
              if(cnt == -1) cnt = d.length;

              nr = d.substr(0, cnt);
              nr = parseInt(nr.replace(/^0/, ''));

              switch(format.charAt(j)) {
                case "d": day = nr; d = d.substr(cnt + 1); break;
                case "m": month = nr; d = d.substr(cnt + 1); break;
                case "y": year = nr; d = d.substr(cnt + 1); break;
              }
            }
            if(!_isDate(year, month, day)) msg += '"' + title + '" ' + msgDate + "\n";
          }
        }

        if(minLength) {
          if(elem.length) {
            if(elem.options) {
              for(j = cnt = 0; j < elem.options.length; j++) {
                if(elem.options[j].selected && elem.options[j].value != "") cnt++;
              }
            }
            else for(j = cnt = 0; j < elem.length; j++) {
              if(elem[j].checked) cnt++;
            }
          }
          else if(elem.type == "checkbox") cnt = elem.checked ? 1 : 0;
          else cnt = val.length;
          if(cnt < minLength) msg += msgFillOut + ' "' + title + '"\n';
        }
      }
      else msg += msgNoField + ': "' + field + '"\n';
    }

    if(msg) alert(msg);
    else document.forms[f].submit();
  }
  else alert(msgNoForm + ': "' + f + '"');
}

//--------------------------------------------------------------------------------------------------------
