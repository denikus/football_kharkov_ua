//$(document).ajaxSend(function(e, xhr, options) {
//  var token = $("meta[name='csrf-token']").attr("content");
//  xhr.setRequestHeader("X-CSRF-Token", token);
//});
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

football.namespace('temp.schedule', {
  autocomplete_cache: {},
  options: {},
  host_team_id: '',
  team: {
    init: function(options) {
      football.temp.schedule.options = options;

      //define host_team_autocomplete handler
      $("#host_team").autocomplete({
        minLength: 2,
        source: function(request, response) {
          if(request.term in football.temp.schedule.autocomplete_cache) {
            response(football.temp.schedule.autocomplete_cache[request.term]);
            return;
          }
          $.ajax({
            url:football.temp.schedule.options.teams_path,
            type: 'POST',
            dataType: 'json',
            data: {search: request, search_type: "host"},
            success: function(data) {
              football.temp.schedule.autocomplete_cache[request.term] = data;
              response(data);
            }
          });
        },
        select: function(event, ui) {
          if(ui.item) {
            football.temp.schedule.team.select_host_team(ui.item.id);
          }
        }
      });
      
      //define guest_team_autocomplete handler
      $("#guest_team").autocomplete({
        minLength: 1,
        source: function(request, response) {
          if (football.temp.schedule.team.host_team_id == '') {
            alert('Please, select host team first');
            return false;
          }
          $.ajax({
            url:football.temp.schedule.options.teams_path,
            type: 'POST',
            dataType: 'json',
            data: {search: request, search_type: "guest", tour_id: $("#schedule_tour_id").val(), host_team_id: football.temp.schedule.team.host_team_id},
            success: function(data) {
              football.temp.schedule.autocomplete_cache[request.term] = data;
              response(data);
            }
          });
        },
        select: function(event, ui) {
          if(ui.item) {
            football.temp.schedule.team.select_guest_team(ui.item.id);
          }
        }
      });

      $("#tournament_id").bind('change', function(e) {

        $.ajax({
            url:'/admin/temp/get_tours',
            type: 'GET',
            dataType: 'json',
            data: {tournament_id: $(this).val()},
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
  }
});