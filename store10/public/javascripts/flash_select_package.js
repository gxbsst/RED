
// Yet another IE6 bug fix...
function flash_select_package ()
{ 
document.write("<object  type=\"application/x-shockwave-flash\" ");
document.write("  data=\"/skin/img/store/show.swf\" ");
document.write("  width=\"930\" height=\"455\" id=\"select_package\">");
document.write("  <param name=\"movie\" ");
document.write("    value=\"/skin/img/store/show.swf\" />");
document.write("  <param name=\"allowScriptAcess\" value=\"sameDomain\" />");
document.write("  <param name=\"quality\" value=\"best\" />");
document.write("  <param name=\"bgcolor\" value=\"#000000\" />");
document.write("  <param name=\"wmode\" value=\"transparent\" />");
document.write("  <param name=\"scale\" value=\"noScale\" />");
document.write("  <param name=\"salign\" value=\"TL\" />");
document.write("  <param name=\"FlashVars\" value=\"playerMode=embedded\" />");
document.write("</object>");
return true;
}

