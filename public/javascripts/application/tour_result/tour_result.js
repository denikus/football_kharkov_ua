$(function () {
    var tournament  = $('#tournament_id');
    var season        = $('#season_id');
    var stage           = $('#stage_id');

    season.change(function(obj) {$(this).show();});
    stage.change(function(obj) {
      $(this).show();
      var target =obj.target;
      create_mathes_block(target.options[target.selectedIndex]['value']);
    });

    season.selectChain({
      target: stage,
      url: '/stage/index',
      type: 'post',
      key: "id",
      value: "label",
      data: {}
    });

    // note that we're assigning in reverse order
    // to allow the chaining change trigger to work
    tournament.selectChain({
        target: season,
        url: '/season/index',
        type: 'post',
        key: "id",
        value: "label",
        data: {}
     }).trigger('change');


});

//load template with matches grouped by leagues and tours
function create_mathes_block(stage_id) {
  $.ajax({
    url: '/tour_result/matches_block',
    data: {stage_id: stage_id},
    type: 'post',
    dataType: 'html',
    success: function (data) {
        $("#matches-container").append(data);
        $("#matches_form").show();
        //check all - checkbox event handling
        $("input[id^=check_all_id_]").click(handleCheckAll);
    }
  })
}

//check all - checkbox event handling
function handleCheckAll(obj) {
  var matches = obj.currentTarget["id"].match(/^check_all_id_(.*)/);
  var checked_status = this.checked;
  $("input[id^=match_" + matches[1] + "_]").each(function() {
    this.checked = checked_status;
  });
}