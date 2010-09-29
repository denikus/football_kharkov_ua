class MatchEvent < ActiveRecord::Base
  belongs_to :match
  belongs_to :match_event_type

  default_scope :order => 'minute ASC'

  
  def type
    match_event_type.symbol.to_sym
  end
  
  module Ext
    class EventsProxy < ActiveSupport::BasicObject
      def initialize proxy, options={}
        @association_proxy, @options = proxy, options
      end
      
      def set stat_name, *args
        @association_proxy.set(stat_name, *args).tap do |result|
          if event_type = MatchEventType.find_by_symbol(stat_name)
            Array(result).each do |s|
              event_type.events.add(@options.merge :stat => s, :owner => @association_proxy.proxy_owner)
            end
          end
        end
      end
      #def method_missing m, *args, &block
      #  #@association_proxy.__send__(m, *args, &block).tap do |result|
      #  #  if m.to_s =~ /^(\w+)=$/ and (event_type = MatchEventType.find_by_symbol $1)
      #  #    Array(result).each do |s|
      #  #      event_type.events.add(@options.merge :stat => s, :owner => @association_proxy.proxy_owner)
      #  #    end
      #  #  end
      #  #end
      #  result = @association_proxy.__send__(m, *args, &block)
      #  if m.to_s =~ /^(\w+)=$/ and (event_type = MatchEventType.find_by_symbol $1)
      #    Array(result).each do |s|
      #      event_type.events.add(@options.merge :stat => s, :owner => @association_proxy.proxy_owner)
      #    end
      #  end
      #  result
      #end
    end
    
    def with_events event_options={}
      EventsProxy.new self, event_options
    end
  end
end
