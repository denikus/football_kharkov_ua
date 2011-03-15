module UrlHelper
  def with_subdomain(subdomain)
    subdomain = (subdomain || "")
    subdomain += "." unless subdomain.empty?
    [subdomain, request.domain(TLD_SIZE), request.port_string].join
  end

  def url_for(options = nil)
    if options.kind_of?(Hash) && options.has_key?(:subdomain)
      options[:host] = with_subdomain(options.delete(:subdomain))
    end
    super
  end

  def current_subdomain
    (request.subdomain(TLD_SIZE).present? && request.subdomain(TLD_SIZE) != "www") ? request.subdomain(TLD_SIZE) : nil
  end
end