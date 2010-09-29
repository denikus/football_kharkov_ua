module TourResultHelper
  def match_label(match)
    host  = match.competitors.find(:first, :conditions => {:side => 'hosts'})
    guest = match.competitors.find(:first, :conditions => {:side => 'guests'})
    return "#{host.team[:name]} #{host.stats.find_by_name("score").value} : #{guest.stats.find_by_name("score").value} #{guest.team[:name]}"
  end

  def get_score_classes(host_score, guest_score)
    
  end
end
