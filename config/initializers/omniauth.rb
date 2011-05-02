Rails.application.config.middleware.use OmniAuth::Builder do
  provider :vkontakte, '2304423', 'BPQpptM8Asx45sxdtlhC', :client_options => {:ssl => {:ca_file => '/usr/lib/ssl/certs/ca-certificates.crt'}}
end
#require 'oa-oauth'
#Rails.application.config.middleware.use OmniAuth::Builder do
#  provider :vkontakte, '2304423', 'BPQpptM8Asx45sxdtlhC'
#end
#
#
#
