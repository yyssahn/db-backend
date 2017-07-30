module Productconcern
  def getProductsFromStore (storeList, budget)
    productList = []
    url = "https://admin.duberex.com/vendors/"+ storeList[0]["id"] +"/search.json?auto_off=web_online&categories%5B%5D=Flowers%25&include_subcategory=false&metadata=1&offset=0&order_by=price&sort_order=asc&web_online=true"
    response = HTTParty.get(url).parsed_response
    if response.key? "products"
        flowers = organizeFlowerProducts response["products"]["items"], storeList[0], budget
        url = "https://admin.duberex.com/vendors/"+ storeList[0]["id"] +"/search.json?auto_off=web_online&categories%5B%5D=pre-rolls%25&include_subcategory=false&metadata=1&offset=0&order_by=price&sort_order=asc&web_online=true"
        pre-rolls = HTTParty.get(url).parsed_response["products"]["items"]
        #allProducts = organizePreRollProducts flowers, pre-rolls, storeList[0], budget
    end
    #storeList.each do |store|
    #  url = "https://admin.duberex.com/vendors/"+ store["id"] +"/search.json?auto_off=web_online&categories%5B%5D=Flowers%25&include_subcategory=false&metadata=1&offset=0&order_by=price&sort_order=asc&web_online=true"
    #  response = HTTParty.get(url).parsed_response
    #  if response.key? "products"
    #      flowers = organizeFlowerProducts response["products"]["items"], store, budget
    #  end
    #end
    return productList
  end

  def organizeFlowerProducts (items, store, budget)
    productList = []

    items.each do |item|
      if item["price"].to_f <= budget.to_f
        pushtoList productList, item, store
      else
        puts productList
        return productList
      end

    end
    puts productList
    return productList
  end

  def organizePreRollProducts (flowers, prerolls, store, budget)
  end

  def pushtoList (list, item, store)
    length = list.length
    if length == 0
      list.push({ :productname => item["name"], :price => item["price"], :address => store["address"], :city => store["city"], :storeid => store["id"], :storename => store["name"], :thc => item["thc_range"][0], :thc_value => (item["thc_range"][0].to_f / item["price"].to_f) })
    else
      if (item["price"] == list.last[:price])
          if(item["thc_range"][0] > list.last[:thc])
            list[length-1] = { :productname => item["name"], :price => item["price"], :address => store["address"], :city => store["city"], :storeid => store["id"], :storename => store["name"], :thc => item["thc_range"][0], :thc_value => (item["thc_range"][0].to_f / item["price"].to_f) }
          end
      else
          list.push({ :productname => item["name"], :price => item["price"], :address => store["address"], :city => store["city"], :storeid => store["id"], :storename => store["name"], :thc => item["thc_range"][0], :thc_value => (item["thc_range"][0].to_f / item["price"].to_f) })
      end
    end
  end

end
