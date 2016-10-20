class TeamScheduleSerializer < ActiveModel::Serializer
  attributes :id, :match_on, :match_at, :side, :competitor, :competitor_ott_uid
  has_one :venue

  def side
    team = serialization_options[:team]
    object.host_team_id == team.id ? 'host' : 'guest'
  end

  def competitor_ott_uid
    competitor_team.ott_uid
  end

  def competitor
    competitor_team.name
  end

  def competitor_team
    team = serialization_options[:team]
    object.host_team_id == team.id ? object.guests: object.hosts
  end

end
