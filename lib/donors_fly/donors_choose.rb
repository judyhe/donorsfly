class DonorsFly::DonorsChoose
  API_URL = 'http://api.donorschoose.org/common/json_feed.html'
  API_KEY = 'DONORSCHOOSE'
  
  class << self
    def get_proposals_nearby(geo, max=1)
      path = "centerLat=#{geo[:latitude]}&centerLng=#{geo[:longitude]}&max=#{max}"
      uri = URI.parse(API_URL + '?APIKey=' + API_KEY + '&' + path)
      response = Net::HTTP.get(uri)
      return nil unless response && !response.blank?

      response = JSON.parse(response)
      proposals = []
      if response && response['proposals']
        response['proposals'].each do |proposal|
          proposals << (Proposal.new)
        end
      end
      
      proposals
    end
  end
end