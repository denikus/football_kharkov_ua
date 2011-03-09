class Permission < ActiveRecord::Base
  belongs_to :admin
  
  scope :for_controller, lambda{ |controller| {:conditions => ['controller =?', controller] } }
  
  def self.get_hash
    all.inject({}) do |res, p|
      unless p.nil?
        res[p.admin_id.to_s] ||= {}
        res[p.admin_id.to_s][p.controller] ||= {}
        res[p.admin_id.to_s][p.controller][p.action] = true
        res
      end
    end
  end
end
