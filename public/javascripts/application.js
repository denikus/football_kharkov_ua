// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function() {
  //error block effects
  $("#main-error-block,#main-notice-block,#main-success-block").fadeOut("fast").fadeIn("fast").fadeOut("fast").fadeIn("fast").fadeOut(5000);


/*  $(".sidebar-shop-content-wrap").jCarouselLite({
        btnNext: ".next",
        btnPrev: ".prev",
        visible: 1,
        auto: 10000,
        speed: 1000,
        start: Math.floor(Math.random()*10+1)
  });*/

  //top menu
  $("ul.subnav").parent().append("<span></span>"); //Only shows drop down trigger when js is enabled - Adds empty span tag after ul.subnav

  $("ul.topnav li.drop").hover(function() { //When trigger is clicked...
    //Following events are applied to the subnav itself (moving subnav up and down)
    //    $(this.id + " ul.subnav").show('slow', function(){
    //      $(this).height("auto");
    //    });
    $(this).find("ul.subnav").stop().slideDown(300).show(300, function(){
      $(this).height("auto");
    });

    //Drop down the subnav on click
    $(this).hover(function() {},
      function(){
        $(this).find("ul.subnav").stop().slideUp('slow'); //When the mouse hovers out of the subnav, move it back up
    });

  //Following events are applied to the trigger (Hover events for the trigger)
  }).hover(function() {
      $(this).addClass("subhover"); //On hover over, add class "subhover"
    }, function(){ //On Hover Out
      $(this).removeClass("subhover"); //On hover out, remove class "subhover"
  });

});

// nice effect for scroll
$.easing.dance = function (x, t, b, c, d) {
  var s = 1.70158;
  if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
  return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
}

function addScheduleBlock() {
	// get handle to scrollable API
	var api = $(".schedule-content-wrap").data("scrollable");
	// use API to add our new item. after the item is being added seek to the end
	api.addItem($("#newItem div").clone()).end();
}

