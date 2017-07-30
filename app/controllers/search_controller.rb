class SearchController < ApplicationController
  include Response
  include Locationconcern
  include Productconcern
  require 'httparty'
  require 'openssl'

  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  def json
    puts params[:zipcode]
    puts params[:budget]
    @products = Product.where(:zipcode => params[:zipcode])

    if @products.count == 0
      url = "http://maps.googleapis.com/maps/api/geocode/json?components=country:US|postal_code:#{params[:zipcode]}&sensor=true"
      response = HTTParty.get(url)
      @originAddress = getOriginAddress response.parsed_response["results"][0]
      url = "https://admin.duberex.com/retailers.json?state=#{@originAddress[:state]}"
      response = HTTParty.get(url)
      @storesInState = getStoresInState response.parsed_response, @originAddress
      @storesInStateInfo = getStoresInStateInfo @storesInState, @originAddress
      @closeStores = getCloseStores @storesInState, @storesInStateInfo

      getProductsFromStore @closeStores, params[:budget]
      json_response @closeStores
    else
      json_response @products
    end

  end
end
