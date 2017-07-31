class SearchController < ApplicationController
  include Response
  include Locationconcern
  include Productconcern
  include Productfilterconcern
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

      @getProducts = getProductsFromStore @closeStores, params[:zipcode], params[:budget]
      @filteredList = getHighestTHC @getProducts, params[:budget].to_f
      @filteredList.each do |item|
        product = Product.new(:address => item[:address], :city => item[:city], :price => item[:price], :productname => item[:productname], :storeid =>item[:storeid], :storename => item[:storename], :thc => item[:thc], :zipcode => item[:zipcode], :thcvalue => item[:thc_value])
        product.save
      end
      puts @products.length
      json_response @filteredList
    else
      @products.each do | product |
        product.numtimesseen = product.numtimesseen + 1
        product.save
      end
      json_response @products
    end

  end



end
