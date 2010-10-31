if (undefined == QuickMatchResults) {
  var QuickMatchResults = {};
}

QuickMatchResults = {
  init: function() {
    $("#next-result-day").hide();
    $("#prev-result-day").click(QuickMatchResults.load_results);
    $("#next-result-day").click(QuickMatchResults.load_results);
  },
  load_results: function(event) {
    var direction = QuickMatchResults.get_direction(event.currentTarget.id);
    var direction_date = QuickMatchResults.get_direction_date(direction);
    
    $.ajax({
      type: 'GET',
      url: '/quick_match_results/show',
      data: {direction: direction, direction_date: direction_date, current_date: $("#quick_result_current_date").val(), authenticity_token: authenticity_token },
      dataType: "json",
      success: function(response) {
        $("#quick-match-results-content").html(response.content);
        QuickMatchResults.update_date_handlers();
        $("#quick-result-current-date").html(response.formatted_date);
//          obj.parents("@[id^='following-user-item']").remove();
      }
    });
  },

  //get direction by click_target
  get_direction : function(event_target) {
    var direction = '';
    if (event_target=='prev-result-day') {
      direction = 'prev';
    } else if (event_target=='next-result-day') {
      direction = 'next';
    }
    return direction;
  },
  get_direction_date : function(direction) {
    var direction_date = '';
    if (direction=='prev') {
      direction_date = $("#quick_result_prev_date").val();
    } else if (direction=='next') {
      direction_date = $("#quick_result_next_date").val();
    }
    return direction_date;
  },
  update_date_handlers: function() {
    ('' == $("#quick_result_prev_date").val()) ? $("#prev-result-day").hide() : $("#prev-result-day").show();
    ('' == $("#quick_result_next_date").val()) ? $("#next-result-day").hide() : $("#next-result-day").show();
  }
}