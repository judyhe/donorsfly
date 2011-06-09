class HomeController < ApplicationController

  def index
    @ip = request.remote_ip
    @geo = DonorsFly::SimpleGeo.ip_to_geo(@ip)
    @proposals = DonorsFly::DonorsChoose.get_proposals_nearby(@geo, max=1)
  end
  
end