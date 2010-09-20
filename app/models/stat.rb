require 'generator.rb'

class Stat < ActiveRecord::Base
  belongs_to :statable, :polymorphic => true
  
  def to_tpl
    value.to_s
  end
  
  module Ext
    def get stat_name
      load_target unless loaded?
      st = target.select{ |stat| stat.name == stat_name }.collect(&:value)
      case st.length
      when 0: nil
      when 1: st[0]
      else; st
      end
    end
    
    def set stat_name, *args
      load_target unless loaded?
      ::SyncEnumerator.new(target.select{ |stat| stat.name == stat_name }, args).each do |s, v|
        s.destroy and next if v.nil?
        (s || Stat.new(:name => stat_name, :statable => proxy_owner)).tap{ |s| s.value = v }.save
      end
      reload
      get stat_name
    end
  end
end
