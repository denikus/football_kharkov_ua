=begin

Dir[File.expand_path(File.dirname(__FILE__) + '/../../lib/extensions/*.rb')].each{ |frb| require frb }
Paperclip.send(:extend, FootballExtensions::Paperclip)
=end
