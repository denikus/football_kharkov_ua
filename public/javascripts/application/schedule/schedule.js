if (undefined == Schedule) {
  var Schedule = {};
}

Schedule = {
  prev_date: '',
  next_date: '',
  init: function(init_prev_date, init_next_date) {
    Schedule.prev_date = init_prev_date; 
    Schedule.next_date = init_next_date; 
    Schedule.checkDatesEmptyness();

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
      url: '/schedules/show',
      data: {id: ('prev'==date_type ? Schedule.prev_date : Schedule.next_date ), date_type: date_type},
      type: 'post',
      dataType: 'json',
      success: function(response_data) {
        var prev_date = Schedule.prev_date;
        var next_date = Schedule.next_date;

        var first_schedule_block = $("ul.schedule-list li:first");
        var last_schedule_block = $("ul.schedule-list li:last");

        //shift arrow dates
        Schedule.shiftArrowDates(date_type, response_data.arrow_date);

        //load content to schedule block
        if ('prev'==date_type) {
          $("ul.schedule-list li:last").html(first_schedule_block.html()).attr('id', first_schedule_block.attr('id'));
          first_schedule_block.html(response_data.data).attr('id', prev_date);
        } else {
          $("ul.schedule-list li:first").html(last_schedule_block.html()).attr('id', last_schedule_block.attr('id'));
          last_schedule_block.html(response_data.data).attr('id', next_date);
        }

        //check if we need to hide one of the arrow dates
        Schedule.checkDatesEmptyness();
      }
    });
  },
  shiftArrowDates: function(date_type, date_value) {
    if ('prev'==date_type) {
      Schedule.prev_date = date_value;
      Schedule.next_date = $("ul.schedule-list li:last").attr('id');
    } else {
      Schedule.next_date = date_value;
      Schedule.prev_date = $("ul.schedule-list li:first").attr('id');
    }
  },
  checkDatesEmptyness: function() {
    if (Schedule.prev_date=='') {
      $("a.prev").hide();
    } else {
      $("a.prev").show();
    }
    if (Schedule.next_date=='') {
      $("a.next").hide();
    } else {
      $("a.next").show();
    }
  }
}

