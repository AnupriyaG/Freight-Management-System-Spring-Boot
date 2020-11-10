/*
 * All methods for the Xenoweb reference site
 *
 */
function openInfoWindow(url) { //v2.0
  var theWindow = window.open(url,'Xenoweb_Info','scrollbars=yes,resizable=yes,width=528,height=400');
  theWindow.moveTo(500,100);
}
function openSearchHelpWindow(url) { //v2.0
  var theWindow = window.open(url,'Search','scrollbars=yes,resizable=no,width=680,height=500');
  theWindow.moveTo(500,100);
}
function focusSearchField(elem) {
  elem.focus();
}