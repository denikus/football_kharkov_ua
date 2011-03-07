require "#{Rails.root}/lib/lib.rb"
Dir[File.expand_path(File.dirname(__FILE__) + '/../../lib/extensions/*.rb')].each{ |frb| require frb }

ActionController::Base.send(:include, Extensions::ActionController)
#Paperclip.send(:extend, FootballExtensions::Paperclip)
