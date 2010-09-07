require 'generator.rb'

class Statistic < ActiveRecord::Base
  S = Hash[*all.collect{ |s| [s.symbol.to_sym, s.id] }.flatten].freeze rescue {}
  Ext = Module.new do
    S.each do |sym, id|
      define_method(sym) do
        stats = target.select{ |s| s.statistic_id == S[sym] }
        stats.empty? ? nil : stats.length == 1 ? stats.first.statistic_value : stats.collect(&:statistic_value)
      end
      
      define_method(sym.to_s+'=') do |val|
        SyncEnumerator.new(target.select{ |s| s.statistic_id == S[sym] }, Array(val)).each do |s, v|
          s.destroy and next if v.nil?
          (s || Stat.new(:statistic_id => S[sym], :statable => proxy_owner)).tap{ |s| s.statistic_value = v }.save
        end
        reload
      end
    end
  end
end
