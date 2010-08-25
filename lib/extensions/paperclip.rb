=begin

module FootballExtensions
  module Paperclip
    def self.extended base
      base.module_eval do
        class << self
          def run_with_zero_fix cmd, *params
            params.each{ |p| p.gsub!(/(\[0\])$/, '') if p.is_a?(String) and p =~ /\[0\]$/ }
            run_without_zero_fix cmd, *params
          end
          alias_method_chain :run, :zero_fix
        end
      end
    end
  end
end
=end
