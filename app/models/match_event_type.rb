class MatchEventType < ActiveRecord::Base
  @types ||= {}
  
  def self.[] sym
    @types[sym.to_s] ||= find_by_symbol sym
  end
  
  has_many :match_events do
    def add params
      params[:minute] = params.delete(:stat) if params.key?(:stat) and params[:minute] == :stat
      params[:match_id] ||= params[:owner].match_id if params[:owner]
      params[:message] ||= proxy_owner.template.gsub(/(^:|[\b\s]:)(\w+)/){ s, v = $1, $2; s.gsub(':', '') + lambda{ |o| o.is_a?(ActiveRecord::Base) ? (o.to_tpl rescue ":#{v}") : o.to_s }[params.delete(v.to_sym)] }
      params.delete(:owner) if params.key?(:owner)
      params.delete_if{ |k, v| not %w{match_id minute message}.include? k.to_s }
      create params
    end
  end
  
  alias_method :events, :match_events
end