class VenueSerializer < ActiveModel::Serializer
  attributes :id, :name, :short_name, :page_title, :ott_uid

  def ott_uid
    nil
  end
end
