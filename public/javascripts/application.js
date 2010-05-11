// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function initOverLabels () {
  if (!document.getElementById) return;   

  var labels, id, field;

  // Set focus and blur handlers to hide and show 
  // LABELs with 'overlabel' class names.
  labels = document.getElementsByTagName('label');
  for (var i = 0; i < labels.length; i++) {
  
    if (labels[i].className == 'overlabel') {

      // Skip labels that do not have a named association
      // with another field.
      id = labels[i].htmlFor || labels[i].getAttribute('for');
      if (!id || !(field = document.getElementById(id))) {
        continue;
      }

      // Change the applied class to hover the label 
      // over the form field.
      labels[i].className = 'overlabel-apply';

      // Hide any fields having an initial value.
      if (field.value !== '') {
        hideLabel(field.getAttribute('id'), true);
      }

      // Set handlers to show and hide labels.
      field.onfocus = function () {
        hideLabel(this.getAttribute('id'), true);
      };
      field.onblur = function () {
        if (this.value === '') {
          hideLabel(this.getAttribute('id'), false);
        }
      };

      // Handle clicks to LABEL elements (for Safari).
      labels[i].onclick = function () {
        var id, field;
        id = this.getAttribute('for');
        if (id && (field = document.getElementById(id))) {
          field.focus();
        }
      };

    }
  }
};

function hideLabel (field_id, hide) {
  var field_for;
  var labels = document.getElementsByTagName('label');
  for (var i = 0; i < labels.length; i++) {
    field_for = labels[i].htmlFor || labels[i].getAttribute('for');
    if (field_for == field_id) {
      labels[i].style.textIndent = (hide) ? '-1000px' : '0px';
      return true;
    }
  }
}

window.onload = function () {
  setTimeout(initOverLabels, 50);
};

$(document).ready(function() {
  $("ul.subnav").parent().append("<span></span>"); //Only shows drop down trigger when js is enabled (Adds empty span tag after ul.subnav*)

  $("ul.topnav li span").click(function() { //When trigger is clicked...
    //Following events are applied to the subnav itself (moving subnav up and down)
    $(this).parent().find("ul.subnav").slideDown('fast').show(); //Drop down the subnav on click

    $(this).parent().hover(function() {
    }, function(){
     $(this).parent().find("ul.subnav").slideUp('slow'); //When the mouse hovers out of the subnav, move it back up
    });

   //Following events are applied to the trigger (Hover events for the trigger)
   }).hover(function() {
     $(this).addClass("subhover"); //On hover over, add class "subhover"
   }, function(){	//On Hover Out
     $(this).removeClass("subhover"); //On hover out, remove class "subhover"
  });

  //error block effects
  $("#main-error-block,#main-notice-block,#main-success-block").fadeOut("fast").fadeIn("fast").fadeOut("fast").fadeIn("fast").fadeOut(5000);
});
