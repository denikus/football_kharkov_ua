class Permission < ActiveRecord::Base
  belongs_to :admin
  
  named_scope :for_controller, lambda{ |controller| {:conditions => ['controller =?', controller] } }
  
  def self.get_hash
    all.inject({}) do |res, p|
      res[p.admin_id.to_s] ||= {}
      res[p.admin_id.to_s][p.controller] ||= {}
      res[p.admin_id.to_s][p.controller][p.action] = true
      res
    end
  end
end
