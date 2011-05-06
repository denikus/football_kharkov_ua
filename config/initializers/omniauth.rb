Rails.application.config.middleware.use OmniAuth::Builder do
  provider :vkontakte, '2304423', 'BPQpptM8Asx45sxdtlhC', :client_options => {:ssl => {:ca_file => '/usr/lib/ssl/certs/ca-certificates.crt'}}
  provider :facebook, '88a23ef766664f3380d02de4536980fa', '7731cf1474f8e9ae4e0080407918aebd', :client_options => {:ssl => {:ca_file => '/usr/lib/ssl/certs/ca-certificates.crt'}}
end
#require 'oa-oauth'
#Rails.application.config.middleware.use OmniAuth::Builder do
#  provider :vkontakte, '2304423', 'BPQpptM8Asx45sxdtlhC'
#end
#
#
#
