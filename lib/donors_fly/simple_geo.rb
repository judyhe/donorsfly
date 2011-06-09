class DonorsFly::SimpleGeo

  class << self
    def ip_to_geo(ip)
      place = SimpleGeo::Client.get_context_ip(ip)
      place[:query]
    end
    
    def address_to_geo(address)
      place = SimpleGeo::Client.get_context_by_address(address)
      place[:query]
  end
end