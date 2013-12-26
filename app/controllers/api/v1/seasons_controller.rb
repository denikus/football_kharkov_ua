class Api::V1::SeasonsController < Api::V1::BaseController
  before_filter :find_tournament

  def index
    @seasons = StepSeason.by_tournament(@tournament.id).order(created_at: :asc).collect{|item|
                  {
                    id: item.id,
                    created_at: item.created_at,
                    updated_at: item.updated_at,
                    name: item.name,
                    url: item.url
                  }
                }

    respond_to do |format|
      format.json{ render json: {seasons: @seasons} }
    end
  end
end
