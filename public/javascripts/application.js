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

  $("a.find_instapaper_reference").click(function() {
    // make an ajax request, display loading thing
    // on success, populate the form, hide the spinner, show the form
    $.getJSON(this.href, function(data) {
      if(data['instapaper_reference']) {
        var title = data['instapaper_reference']['title'];
        var url = data['instapaper_reference']['url'];
        console.log(title,url);
        $(this).parent().siblings(".instapaper_form").show();
      }
    });
    return false;
  });
});
