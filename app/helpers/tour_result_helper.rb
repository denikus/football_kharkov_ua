module TourResultHelper
  def match_label(match)
    host  = match.competitors.find(:first, :conditions => {:side => 'hosts'})
    guest = match.competitors.find(:first, :conditions => {:side => 'guests'})

    return "#{host.team[:name]} #{host.stats.score} : #{guest.stats.score} #{guest.team[:name]}"
  end
end
