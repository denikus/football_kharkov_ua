// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//= require application/schedule/schedule.js
//= require jquery-plugins/jquery_form/jquery.form.js
//= require application/comment/comment.js
//= require ckeditor/init.js
//= require application/profile/profile.js
//= require jquery-plugins/jquery.Jcrop.min
//= require extensions.js
//= require jquery-plugins/jquery.scrollTo-min

$(document).ajaxSend(function(e, xhr, options) {
  var token = $("meta[name='csrf-token']").attr("content");
  xhr.setRequestHeader("X-CSRF-Token", token);
});


if (!FHU) var FHU = {};

$(function() {
  //error block effects

  new FHU.topNav();
  new FHU.comments();
  // new FHU.share();

});

FHU.share = function() {
  this.share = function() {
    var shareBox = $('#letsShare'),
        shareHover = shareBox.children(".hoverLayer");

    shareBox.hover(function(){
      shareHover.stop().animate({"height": "0"}, 500);
    }).mouseleave(function(){
      shareHover.stop().animate({"height": "50px"}, 500);
    })    
  };

  this.share();
};

FHU.comments = function() {
  this.comments = function() {
    navigate();
  }
  var navigate = function() {
    var lnkGoToParent = $("#comment-tree a.goToParent"),
        lnkBackToChildId = "backToChild",
        lnkBackToChildHtml = '<li><a class="backToChild" id="' + lnkBackToChildId + '" href="#">Назад к ответу</a></li>';

    lnkGoToParent.click(function() {
      var self = $(this);
      var anchorToGo = self.attr("href"),
          anchorToBack = self.parents("li.comment").attr("id");

      goToComment(anchorToGo);
      removeBackToChildLink();
      setBackToChildLink(anchorToGo, anchorToBack);

      return false;
    });

    $("#" + lnkBackToChildId).on("click", function() {
      var self = $(this);
      var anchorToBack = self.attr("href");
      goToComment(anchorToBack);
      removeBackToChildLink();
      return false;
    });

    // scroll to the comment with @id
    var goToComment = function(idToGo) {
      var movingSpeed = 500;
      $.scrollTo(idToGo, movingSpeed);
    };
    // remove the "back to child" link
    var removeBackToChildLink = function() {
      $("#" + lnkBackToChildId).parent("li").remove();
    };
    // set the "back to child" link (add to the DOM and set a "href" attribute)
    var setBackToChildLink = function(anchorToGo, anchorToBack) {
      $(anchorToGo).find(".options ul").append(lnkBackToChildHtml);
      $("#" + lnkBackToChildId).attr("href", "#" + anchorToBack);      
    };
  }

  this.comments();
}

FHU.topNav = function() {

  this.topNav = function() {
    //top menu
    $("ul.subnav").parent().append("<span></span>"); 

    $("ul.topnav li.drop").hover(function() {
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
        $(this).addClass("subhover");
      }, function() {
        $(this).removeClass("subhover");
    });    
  }

  this.topNav();  
}

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