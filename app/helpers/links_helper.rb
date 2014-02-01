module LinksHelper
  
  def link_domain(link)
    link.link_url.match(/([(\w|\-)]+\.)+[\w]+/)[0]
  end
end

