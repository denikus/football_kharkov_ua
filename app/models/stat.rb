class Stat < ActiveRecord::Base
  belongs_to :statable, :polymorphic => true
  belongs_to :statistic
  
  def initialize(options)
    super(options)
  rescue ActiveRecord::UnknownAttributeError => e
    if e.message =~ /\b([\w_]+)$/
      param = $1.to_sym; value = options.delete(param)
      raise if (stat_id = Statistic::S[param.to_sym]).nil?
      options[:statistic_id] = stat_id
      options[:statistic_value] = value
      retry
    else
      raise
    end
  end
end
