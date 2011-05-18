class FootballerCell < Cell::Rails
  include Devise::Controllers::Helpers

  def sidebar
    id = params[:id].nil? ? params[:footballer_id] : params[:id]
    @footballer = Footballer.find_by_url(id)
    
    render
  end
end
