// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
  $(".import-file-fields").hide();
  $(".file-import-dropdown").click(function() {
    $(".import-file-fields").toggle();
    return false;
  });
});