# -*- encoding : utf-8 -*-
module Secured
  def self.included(base)
    base.instance_variable_set(:@secured_actions, [])
    base.extend(ClassMethods)
  end

  module ClassMethods
    def secure *args
      options = args.extract_options!
      @secured_actions = args.collect(&:to_s)
    end

    def secured_actions
      @secured_actions
    end

    def permit user
      Proc.new do |controller|
        raise ArgumentError.new("Cant check permissions for #{user} - it is not authenticatable") unless controller.respond_to?(:"current_#{user}")
        raise ArgumentError.new("Cant check permissions for #{user} - it is not authenticated") if controller.send(:"current_#{user}").nil?

        unless controller.send(:"current_#{user}").super_user
          if controller.class.secured_actions.include? controller.action_name
            unless controller.send(:"current_#{user}").permissions.for_controller(controller.class.to_s).collect(&:action).include? controller.action_name
              controller.respond_to do |format|
                format.html { controller.send(:render, :text => 'Not permitted') }
                format.js { controller.send(:render, :json => {:status => :not_permitted}) }
              end
            end
          end
        end
      end
    end
  end

end
