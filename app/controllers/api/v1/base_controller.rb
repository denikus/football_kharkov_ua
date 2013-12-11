class Api::V1::BaseController < ActionController::Base
  respond_to :json

  def default_format_json
    request.format = :json unless params[:format]
  end

  def error!(message, status)
    render json: { error: message }, status: status
  end

  def set_link_headers(collection, route, options = {})
    links = {}
    link_options = options.merge(extended: params[:extended], per_page: params[:per_page]).delete_if{ |_, v| v.blank? }

    if params.key?(:from)
      links[:next] = method(route).call(link_options.merge(from: collection.last.id)) if collection.last
    else
      links[:prev] = method(route).call(link_options.merge(page: collection.previous_page)) if collection.respond_to?(:previous_page)
      links[:next] = method(route).call(link_options.merge(page: collection.next_page)) if collection.respond_to?(:next_page) && !collection.next_page.nil?
    end
    headers['Link'] = links.collect{ |k, v| "<#{v}>; rel=\"#{k}\"" }.join(', ')
  end

  private

  def find_tournament
    @tournament = Tournament.find_by_url(params[:tournament_id])
    rescue ActiveRecord::RecordNotFound
      error = { :error => "The tournament you were looking for could not be found."}
      respond_with(error, :status => 404)
  end
end