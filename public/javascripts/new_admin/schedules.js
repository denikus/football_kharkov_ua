$(function () {
  var host_team  = $('#schedule_host_team_id');
  var guest_team  = $('#schedule_guest_team_id');


  host_team.selectChain({
        target: guest_team,
        url: '/admin/teams/index',
        type: 'post',
        key: "id",
        value: "label",
        data: {test: '1'}
     }).trigger('change');
});