# -*- encoding : utf-8 -*-
module Admin::LeaguesHelper
  def content_for_sidebar
    render :partial => 'admin/shared/tournaments_sidebar'
  end
end
