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
});
