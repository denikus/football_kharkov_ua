football = {
  namespace: function(name, obj) {
    obj = obj || {};
    return $.extend(name.split('.').inject(this, function(o, n){ if(!o[n]){ o[n] = {} } return o[n]; }), obj);
  },
  create: function(func, obj) {
    if('prototype' in obj) {
      func.prototype = obj.prototype;
      delete obj.prototype;
    }
    if('extend' in obj) {
      $.extend(func, obj.extend);
      delete obj.extend;
    }
    $.extend(func.prototype, obj);
    return func;
  },
  extend: function(parent, obj) {
    if(typeof obj.initialize != 'function') obj.initialize = function(){ parent.apply(this, arguments); };
    var child = function(){ obj.initialize.apply(this, arguments) };
    delete obj.intialize;
    child.prototype.parent = parent.prototype;
    for(var k in parent.prototype) {
      if(typeof parent.prototype[k] == 'function') {
        child.prototype[k] = parent.prototype[k];
      }
    }
    $.extend(child.prototype, obj);
    return child;
  }
};


football.namespace('temp.import', {
  init: function(options) {
    $("#season_id").bind('change', function(e) {

      $.ajax({
          url:'/admin/import/get_stages',
          type: 'GET',
          dataType: 'json',
          data: {season_id: $(this).val()},
          success: function(data) {
            var select_content = '';
            for(var i = 0; i < data.length; i++) {

              select_content += '<option value="' + data[i].value + '"' + (i==(data.length-1) ? " selected=\"selected\"" : "") + '>' + data[i].text + '</option>';
            }
            $("#schedule_tour_id").html(select_content);
          }
        });


    });
  },
  select_host_team: function(team_id){
    $("#schedule_host_team_id").val(team_id);
    football.temp.schedule.team.host_team_id = team_id;

  },
  select_guest_team: function(team_id) {
    $("#schedule_guest_team_id").val(team_id);
  }
});