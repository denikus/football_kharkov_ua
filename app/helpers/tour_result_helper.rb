module TourResultHelper
  def match_label(match)
    host  = match.competitors.find(:first, :conditions => {:side => 'hosts'})
    guest = match.competitors.find(:first, :conditions => {:side => 'guests'})
    return "#{host.team[:name]} #{host.stats.find_by_name("score").value} : #{guest.stats.find_by_name("score").value} #{guest.team[:name]}"
  end

  def get_score_classes(hosts_score, guests_score)
    winner_class = "fancy-score-winner"
    loser_class = "fancy-score-loser"
    style_classes = {:hosts_class => "", :guests_class => ""}
    if hosts_score > guests_score
      style_classes[:hosts_class] = winner_class
      style_classes[:guests_class] = loser_class
    elsif hosts_score < guests_score
      style_classes[:hosts_class] = loser_class
      style_classes[:guests_class] = winner_class
    end
    return style_classes
  end
end
