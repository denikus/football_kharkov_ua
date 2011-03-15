class Subdomain
  def self.matches?(request)
    request.subdomain(TLD_SIZE).present? && request.subdomain(TLD_SIZE) != "www"
  end
end