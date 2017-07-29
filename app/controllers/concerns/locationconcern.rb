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

  def getCloseStores (response, origin)
    closeStores = []
    i = 0
    puts response.length
    response.each do |store|
      if store["zip_code"] == origin[:zip_code]
        closeStores.push(store)
        response.delete_at(i)
        puts i
        puts store
      else
        i+=1
      end

    end
    puts response.length

    return closeStores
  end
end
