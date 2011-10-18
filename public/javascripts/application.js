// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
  // from bootstrap-dropdown.js
   $('#topbar').dropdown()

  /* import link from topbar */

  $(".import-from-kindle").click(function() {
    $("form.invisible").submit();
    return false;
  });

  /* import modal dialog */
  $(".submit-file-upload").click(function() {
    $(this).parents("form").submit();
    return false;
  });

  /* single post modal dialogue */

  $(".clipping_html_export").click(function() {
    $("#exportmodal").remove();
    $.get(this.href, function(data) {
      var modalHTML = "<div id='exportmodal' class='modal'><div class='modal-header'><a href='#' class='close'>&times;</a><h3>Export Clipping as HTML</h3><div class='modal-body'><form><textarea class='xxlarge' rows='8'>" + data + "</textarea></form></div></div></div>";
      $(modalHTML).appendTo('body').modal();
    });
    return false;
  });

  $("#exportmodal .close").live("click", function() {
    $(this).parents(".modal").remove();
    return false;
  });

  
  $(".book_html_export").click(function() {
    $("#exportmodal").remove();
    $.get(this.href, function(data) {
      var modalHTML = "<div id='exportmodal' class='modal'><div class='modal-header'><a href='#' class='close'>&times;</a><h3>Export Book as HTML</h3><div class='modal-body'><form><textarea class='xxlarge' rows='8'>" + data + "</textarea></form></div></div></div>";
      $(modalHTML).appendTo('body').modal();
    });
    return false;
  });

  /* instapaper form stuff */

  $(".instapaper_form").hide();
  $(".form_spinner").hide();

  $("a.toggle_instapaper_form").live("click", function() {
    $(this).parent().siblings(".instapaper_form").slideDown("fast");
    populateInstapaperForm(this);
    return false;
  });

  $("a.cancel_instapaper_ref_form").click(function() {
    $(this).parents(".instapaper_form").slideUp("fast");
    return false;
  });

  $("img.instapaper_spinner").hide();
  $("a.find_instapaper_reference").click(function() {
    // make an ajax request, display loading thing
    populateInstapaperForm(this);
    return false;
  });

  $(".instapaper_form form").submit(function(e) {
    var formUrl = $(this).attr("action");
    var form = $(this);
    var spinner = $(this).find(".form_spinner");
    $(spinner).show();
    e.preventDefault();

    // post via AJAX
    $.post(formUrl,
           $(this).serialize(),
           function(d) {
            // TODO: now refresh the front-end with the replaced text
             $.getJSON(formUrl + ".json", function(data) {
               if(data['instapaper_reference']) {
                 $(form).hide();
                 var url = data['instapaper_reference']['url'];
                 var title = data['instapaper_reference']['title'];
                  //remove any "Find Reference form
                 $(form).parents(".instapaper").children(".find_reference").remove();
                 $(form).parents(".instapaper").children(".show_reference").remove();
                 $(form).parents(".instapaper").prepend("<p class='show_reference'><b>From:</b> <a href='" + url + "'>" + title + "</a> <a href='" + formUrl + "/new" + "' class='toggle_instapaper_form'>(edit)</a></p>"); 
                 $(spinner).hide();
                 $(form).hide();
               }
             });
           });
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
