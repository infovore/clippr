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
    populateInstapaperForm(this);
    return false;
  });

  $("a.cancel_instapaper_ref_form").click(function() {
    $(this).parents(".instapaper_form").hide();
    return false;
  });

  $("img.instapaper_spinner").hide();
  $("a.find_instapaper_reference").click(function() {
    // make an ajax request, display loading thing
    populateInstapaperForm(this);
    return false;
  });

  $(".instapaper_form form").submit(function(e) {
    $(this).hide();
    //e.preventDefault();
    // TODO: now refresh the front-end with the replaced text
  });
});

function populateInstapaperForm(elm) {
 $(elm).siblings(".instapaper_spinner").show();
  var form = $(elm).parent().siblings(".instapaper_form");
  // on success, populate the form, hide the spinner, show the form
  $.getJSON(elm.href + ".json", function(data) {
    if(data['instapaper_reference']) {
      var title = data['instapaper_reference']['title'];
      var url = data['instapaper_reference']['url'];
      form.find("input[name='instapaper_reference[url]']").val(url);
      form.find("input[name='instapaper_reference[title]']").val(title);
      $("img.instapaper_spinner").hide();
      form.show();
    }
  });
}
