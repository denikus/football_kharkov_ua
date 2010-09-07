module Admin::TournamentsHelper
  def content_for_sidebar
    render :partial => 'admin/shared/tournaments_sidebar'
  end
end
