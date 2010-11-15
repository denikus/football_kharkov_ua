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
    $("img.prev").click(function() {
      Schedule.loadDay('prev');
    });
  },
  loadDay: function(date_type) {
    if ('prev'==date_type) {
      day_date = Schedule.prev_date
    } else {
      day_date = Schedule.next_date
    }

    $.ajax({
      url: '/schedules/show',
      data: {id: day_date, date_type: date_type},
      type: 'post',
      dataType: 'json',
      success: function(response_data) {
        if ('prev'==date_type) {
          Schedule.prev_date = response_data.arrow_date;
        } else {
          Schedule.next_date = response_data.arrow_date;
        }
      }
    });
  },
  checkDatesEmptyness: function() {
    if (Schedule.prev_date=='') {
      $("img.prev").hide();
    } else {
      $("img.prev").show();
    }
    if (Schedule.next_date=='') {
      $("img.next").hide();
    } else {
      $("img.next").show();
    }
  }
}

