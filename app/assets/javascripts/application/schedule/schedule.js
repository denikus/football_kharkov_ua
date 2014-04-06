if (undefined == Schedule) {
  var Schedule = {};
}

Schedule = {
  min_date: '',
  max_date: '',
  current_date: '',
  url: '/schedules/show',
  format: '',
  init: function(min_date, max_date, current_date, format) {
    Schedule.min_date = min_date;
    Schedule.max_date = max_date;
    Schedule.current_date = current_date;
    Schedule.format = format;

    Schedule.checkArrows();

    //handle prev button click    
    $("a.prev").click(function() {
      Schedule.loadDay('prev');
      return false;
    });

    $("a.next").click(function() {
      Schedule.loadDay('next');
      return false;
    });
  },
  loadDay: function(date_type) {

    $.ajax({
      url: Schedule.url,
      data: {id: Schedule.current_date, date_type: date_type, format: Schedule.format },
      type: 'post',
      dataType: 'script',
      success: function(response_data) {
      }
    });
  },
  checkArrows: function() {
    (Schedule.current_date == Schedule.min_date) ? $("a.prev").hide() : $("a.prev").show();
    (Schedule.current_date == Schedule.max_date) ? $("a.next").hide() : $("a.next").show();
  },
  quick_results: {
    current_score: '-',
    init: function() {
      $("div.fancy-score").on('click', Schedule.quick_results.container_click_handler);
    },
    container_click_handler: function(event) {

      Schedule.quick_results.current_score = $(this).text();
      var schedule_id = $(this).attr("id").match(/\d+$/);
      var team_type = $(this).attr("id").match(/^[a-zA-Z]+/);
      var input_field_id = team_type + "_score_" + schedule_id;
      $(this).html('<input name="' + team_type + '_score" class="fancy_score_edit" type="text" value="' + ( Schedule.quick_results.current_score!='-' ? Schedule.quick_results.current_score : "" ) + '" id="' + input_field_id + '" />');
      $("input#" + input_field_id + "").focus();

      //events binding
      $("div.fancy-score input").on('keydown', Schedule.quick_results.input_field_keydown_handler);
      $("div.fancy-score input").on('blur', Schedule.quick_results.input_field_blur_handler);
    },
    input_field_keydown_handler: function(event) {s
      var input_field = $(this);
      var sched_id  = input_field.attr("id").match(/\d+$/);
      var score     = input_field.val();
      var team_type = input_field.attr("id").match(/^[a-zA-Z]+/);
      //check if enter button pressed
      if (event.keyCode == '13') {
        Schedule.quick_results.save_score(sched_id, score, team_type[0]);
      //check if escape button pressed
      } else if (event.keyCode == '27') {
        Schedule.quick_results.cancel_score(team_type + "_score_view_" + sched_id);
      }
    },
    input_field_blur_handler: function() {
      var input_field = $(this);
      var sched_id  = input_field.attr("id").match(/\d+$/);
      var score     = input_field.val();
      var team_type = input_field.attr("id").match(/^[a-zA-Z]+/);
      Schedule.quick_results.save_score(sched_id, score, team_type[0]);
    },
    save_score: function(schedule_id, score, team_type) {
      $.ajax({
        url: '/schedules/' + schedule_id,
        data: {score: score, team_type: team_type},
        type: 'PUT',
        dataType: 'json',
        success: function(response_data) {
          $("#" + team_type + "_score_view_" + schedule_id +"").text(score);
        }
      });
    },
    cancel_score: function(container_id) {
      $("#" + container_id +"").text(Schedule.quick_results.current_score);
    }

  }
}

