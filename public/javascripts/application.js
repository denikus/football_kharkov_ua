// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function() {
  //error block effects
  $("#main-error-block,#main-notice-block,#main-success-block").fadeOut("fast").fadeIn("fast").fadeOut("fast").fadeIn("fast").fadeOut(5000);

//  $("div.sidebar-shop-content").carousel({});

  $(".sidebar-shop-content-wrap").jCarouselLite({
        btnNext: ".next",
        btnPrev: ".prev",
        visible: 1,
        auto: 5000,
        speed: 1000,
        start: Math.floor(Math.random()*10+1)
  });

  //top menu
  $("ul.subnav").parent().append("<span></span>"); //Only shows drop down trigger when js is enabled - Adds empty span tag after ul.subnav

//  $("ul.topnav li.drop ul.subnav").slideDown('slow');

  $("ul.topnav li.drop").hover(function() { //When trigger is clicked...
    //Following events are applied to the subnav itself (moving subnav up and down)
//    $(this.id + " ul.subnav").show('slow', function(){
//      $(this).height("auto");
//    });
    $(this).parent().find("ul.subnav").stop().slideDown('slow').show('slow', function(){
      $(this).height("auto");
    }); //Drop down the subnav on click

    $(this).hover(function() {},
      function(){
        $(this).find("ul.subnav").stop().slideUp('slow'); //When the mouse hovers out of the subnav, move it back up
//        $(this).find("ul.subnav").hide('slow'); //When the mouse hovers out of the subnav, move it back up
    });


//    $(this).parent().hover(function() {
//      }, function(){
//      $(this).parent().find("ul.subnav").stop().slideUp('slow'); //When the mouse hovers out of the subnav, move it back up
//    });

  //Following events are applied to the trigger (Hover events for the trigger)
  }).hover(function() {
      $(this).addClass("subhover"); //On hover over, add class "subhover"
    }, function(){ //On Hover Out
      $(this).removeClass("subhover"); //On hover out, remove class "subhover"
  }); 
});
