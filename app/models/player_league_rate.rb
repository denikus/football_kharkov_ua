class PlayerLeagueRate

  attr_reader :rate

  def initialize (football_player)
    @rate = 0

    @player_stats = football_player.player_stats

    @rate += 3 * @player_stats['goal'] + 2 * @player_stats['goal_10'] + @player_stats['goal_6'] - @player_stats['auto_goal']
      - @player_stats['yellow_card'] - 3 * @player_stats['red_card']
  end
end