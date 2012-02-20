# -*- encoding : utf-8 -*-
require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "create match record and competitor records with schedule record" do
    match_time = "14:00"
    match_date = Time.now.tomorrow
    schedule = Schedule.create({:venue_id => 1,
                                :tour_id => 1,
                                :match_on => match_date,
                                :match_at => match_time,
                                :host_team_id => 1,
                                :guest_team_id => 2
                              })
    assert_not_nil schedule.match

    # check if competitors record is exists
    assert_not_nil schedule.match.hosts
    assert_not_nil schedule.match.guests

    #check if guests and hosts created correctly
    assert_equal(schedule.match.hosts.team_id, 1)
    assert_equal(schedule.match.guests.team_id, 2)
  end
end
