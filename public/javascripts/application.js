// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
  $(".import-file-fields").hide();
  $(".file-import-dropdown").click(function() {
    $(".import-file-fields").toggle();
    return false;
  });

  $(".instapaper_form").hide();
  $("a.toggle_instapaper_form").click(function() {
    $(this).parent().siblings(".instapaper_form").show();
    return false;
  });
  $("a.cancel_instapaper_ref_form").click(function() {
    $(this).parents(".instapaper_form").hide();
    return false;
  });
});
