class Subdomain
  def self.matches?(request)
#    subdomain = request.subdomain.split(".")[0]
#    subdomain.present? && subdomain != 'www'
    request.subdomain.present? && request.subdomain != 'www'
  end

  
end