if (undefined == Itleague) {
  var Itleague = {};
}
Itleague.draw = {
  counter: 0,
  stage: 1,
  baskets: ["basket-1", "basket-2", "basket-3", "basket-4"],
  groups: ["group-e", "group-d", "group-c", "group-b", "group-a"],
  last_team: '',
  init: function() {
    //buttons
    $("button#mega-button").button({disabled: false});
    $("button#cancel-button").button({disabled: true});

    //first stage button handler
    $("#mega-button").click(function() {

      var basket_items = $("ol#" + Itleague.draw.baskets[Itleague.draw.stage-1]).children().not("[class*=drawed]");

//      var groups = ["group-e", "group-d", "group-c", "group-b", "group-a"];
      $(this).find("span.ui-button-text").text('Продолжить');
      $("button#cancel-button").button("disable");
      Itleague.draw.runCarousel(basket_items, 0);
    });

    $("button#cancel-button").click(function(){
      $(Itleague.draw.last_team).removeClass("drawed");
      $("li#" + Itleague.draw.last_team.id + "-group").remove();
      Itleague.draw.counter--;
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
  runCarousel: function(data, i) {
    var group_id;
    var interval_id = window.setInterval(function() {
      i = (i == data.length || i=='undefined') ? 0 : i; // loops the interval
      prev = i;
      $(data[i++]).trigger('click');
    }, 100);
    window.setTimeout(function(){
      window.clearInterval(interval_id);
      if (Itleague.draw.counter<=4) {
        group_id = Itleague.draw.groups[Itleague.draw.counter];
      } else {
        group_id = Itleague.draw.groups[0];
      }
//      console.log("prev: " + prev);
//      console.log("id: " + data[prev].id);
//      if (Itleague.draw.stage==2) {
//        alert(data);
//      }

      $(data[prev]).clone().attr("id", data[prev].id + "-group").appendTo("ol#" + group_id + ":first").hide().delay(1000).fadeIn("slow");
      Itleague.draw.last_team = data[prev];
      $(data[prev]).addClass("drawed");
      Itleague.draw.counter++;

      if (data.length==1) {
        if (Itleague.draw.stage>=4){
          $("#mega-button").disable();
          $("#mega-button").find("span.ui-button-text").text("Жеребьевка завершена!");
        } else {
          $("#mega-button").find("span.ui-button-text").text(++Itleague.draw.stage + "-й Этап");

          $("button#cancel-button").button("disable");
        }
        Itleague.draw.counter = 0;
      } else {
        $("button#cancel-button").button("enable");
      }

    }, Math.random()*11*(new Date().getSeconds())*data.length*10);

  }
}

$(function() {
  Itleague.draw.init();
});
