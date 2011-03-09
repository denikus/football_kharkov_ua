module UrlHelper
  def with_subdomain(subdomain)
#    subdomain = current_subdomain
    subdomain = (subdomain || "")
    subdomain += "." unless subdomain.empty?
    [subdomain, DOMAIN_HOST, request.port_string].join
#    "asdasd"
  end

  def current_subdomain
    puts "host: #{request.host}"
    puts "domain: #{request.domain}"
    puts "subdomains: #{request.subdomains}"
    subdomain = request.subdomains(TLD_SIZE-1).join(".")
    puts "subdomain: #{subdomain}"
#    debugger


    (subdomain!=false && !subdomain.blank?) ? subdomain : nil
#    request.subdomain.empty? ? nil : request.subdomain
  end

end