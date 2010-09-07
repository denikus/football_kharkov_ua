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
    #def method_missing m, *args, &block
    #  m = m.to_s
    #  return send(m[0...-1], *args, &block) if m[-1] == ?!
    #  name, assign = m[-1] == ?= ? [m[0...-1], true] : [m, false]
    #  load_target unless loaded?
    #  if assign
    #    ::SyncEnumerator.new(target.select{ |s| s.name == name }, Array(args)).each do |s, v|
    #      s.destroy and next if v.nil?
    #      (s || Stat.new(:name => name, :statable => proxy_owner)).tap{ |s| s.value = v }.save
    #    end
    #    reload
    #  else
    #    st = target.select{ |s| s.name == name }.collect(&:value)
    #    case st.length
    #    when 0: nil
    #    when 1: st[0]
    #    else; st
    #    end
    #  end
    #end
  end
end
