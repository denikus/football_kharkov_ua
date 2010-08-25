if (undefined == Itleague) {
  var Itleague = {};
}
Itleague.draw = {
  counter: 0,
  stage: 1,
  baskets: ["basket-4", "basket-3", "basket-2", "basket-1"],
  
  init: function() {
    //buttons
    $("button#mega-button").button({disabled: false});

    //first stage button handler
    $("#mega-button").click(function() {

      var basket_items = $("ol#" + Itleague.draw.baskets[Itleague.draw.stage-1]).children().not("[class*=drawed]");

      var groups = ["group-e", "group-d", "group-c", "group-b", "group-a"];
      $(this).find("span.ui-button-text").text('Продолжить');


      Itleague.draw.runCarousel(basket_items, groups);
    });

    //lists
    $(".group").sortable({
			connectWith: '.group'
		});

    $(".basket").sortable({
			connectWith: '.basket'
		});

		$(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
			.find(".portlet-header")
				.addClass("ui-widget-header ui-corner-all")
				.prepend('<span class="ui-icon ui-icon-minusthick"></span>')
				.end()
			.find(".portlet-content");

		$(".portlet-header .ui-icon").click(function() {
			$(this).toggleClass("ui-icon-minusthick").toggleClass("ui-icon-plusthick");
			$(this).parents(".portlet:first").find(".portlet-content").toggle();
		});

    //linked
    $("ol").sortable({
			connectWith: 'ol'
		});

    $("ol[id*=basket] li").click(function(){
      $(this).parent().children().each(function(){
        $(this).removeClass("ui-selected");
      });
      $(this).not("[class*=drawed]").addClass("ui-selected");
    });

    $("ol[id*=basket] li").dblclick(function(){
      $(this).addClass("drawed");
    });
  },
  runCarousel: function(data, groups) {
    var i;
    var group_id;
    var interval_id = window.setInterval(function() {
      i = (i == data.length || i==undefined) ? 0 : i; // loops the interval
      prev = i;
      $(data[i++]).trigger('click');
    }, 100);
    window.setTimeout(function(){
      window.clearInterval(interval_id);
      if (Itleague.draw.counter<=4) {
        group_id = groups[Itleague.draw.counter];
      } else {
        group_id = groups[0];
      }
      $(data[prev]).clone().appendTo("ol#" + group_id + ":first").hide().delay(1000).fadeIn("slow");
      $(data[prev]).addClass("drawed");
      Itleague.draw.counter++;

      if (data.length==1) {
        if (Itleague.draw.stage>=4){
          $("#mega-button").disable();
          $("#mega-button").find("span.ui-button-text").text("Жеребьевка завершена!");
        } else {
          $("#mega-button").find("span.ui-button-text").text(++Itleague.draw.stage + "-й Этап");
        }
        Itleague.draw.counter = 0;
      }

    }, Math.random()*11*data.length*200 + 5000);

  }
}

$(function() {
  Itleague.draw.init();
});
