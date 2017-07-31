module Locationconcern
  def getOriginAddress(response)
    state = ""
    city = ""
    zip_code =""

    response["address_components"].each do |component|
        if component["types"][0] == "postal_code"
          zip_code = component["short_name"]
        end
        if component["types"][0] == "administrative_area_level_1"
          state = component["short_name"]
        end
        if component["types"][0] == "locality"
          city = component["short_name"]
        end
    end
    lat = response["geometry"]["location"]["lat"]
    lng = response["geometry"]["location"]["lng"]
    return {:state=>state, :city => city, :lat => lat, :lng => lng, :zip_code => zip_code}
  end

  def getStoresInState (response, origin)
    closeStores = []
    i = 0

    response.each do |store|
      if store["zip_code"] == origin[:zip_code]
        if closeStores.length >= 25

          return closeStores
        end
        closeStores.push(store)
        response.delete_at(i)
      else
        i+=1
      end
    end
    i = 0
    response.each do |store|
      if store["city"] == origin[:city]
        if closeStores.length >= 25

          return closeStores
        end
        closeStores.push(store)
        response.delete_at(i)
      else
        i+=1
      end
    end
    return closeStores
  end

  def getStoresInStateInfo (stores, origin)

    destinationquery = stores[0]["address"] + ',' + stores[0]["city"]
    #puts destinationquery
    for i in 1..(stores.length-1)
      destinationquery = destinationquery + "|" +stores[i]["address"] + ',' + stores[i]["city"]
    end
    #puts destinationquery
    closeStores = []
    url = "https://maps.googleapis.com/maps/api/distancematrix/json?" + "units=imperial" + "&origins="+origin[:lat].to_s + "," + origin[:lng].to_s  + "&destinations=" + destinationquery + "&key=AIzaSyABFzbmnvMJT_r9a7OaHLD7Z5oTeHkvyyo"
    response = HTTParty.get(url) #:query =>{:units => "imperial" , :origins => origin[:lat].to_s + "," + origin[:lng].to_s, :destinations => destinationquery, :key => 'AIzaSyABFzbmnvMJT_r9a7OaHLD7Z5oTeHkvyyo'})
    return response.parsed_response

  end

  def getCloseStores(stores, storeInfo)
    closeStores = []
    #puts storeInfo["rows"][0]["elements"][0]["distance"]["value"]
    for i in 1..(stores.length-1)
          if (storeInfo["rows"][0]["elements"][i]["distance"]["value"] < 32187)
            closeStores.push(stores[i])
          end
    end
    return closeStores
  end

end
