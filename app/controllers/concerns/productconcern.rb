module Productconcern
  def getProductsFromStore (storeList, zipcode, budget)
    productList = []


    storeList.each do |store|
      url = "https://admin.duberex.com/vendors/"+ store["id"] +"/search.json?auto_off=web_online&categories%5B%5D=Flowers%25&include_subcategory=false&metadata=1&offset=0&order_by=price&sort_order=asc&web_online=true"
      #puts url
      response = HTTParty.get(url).parsed_response
      if response.key? "products"
          flowers = organizeFlowerProducts response["products"]["items"], store, zipcode, budget
          url = "https://admin.duberex.com/vendors/"+ store["id"] +"/search.json?auto_off=web_online&categories%5B%5D=pre-rolls%25&include_subcategory=false&metadata=1&offset=0&order_by=price&sort_order=asc&web_online=true"
          prerolls = HTTParty.get(url).parsed_response["products"]["items"]
          allProducts = organizePreRollProducts flowers, prerolls, store, zipcode, budget
          allProducts.sort_by{ |item| item[:thc_value]}
          productList.push(allProducts)
      end
      if productList.length >= 3
        return productList
      end
    end
    return productList
  end

  def organizeFlowerProducts (items, store, zipcode, budget)
    productList = []
    #puts items
    #puts items.count
    items.each do |item|
      if item["price"].to_f <= budget.to_f
        pushtoList productList, item, store, zipcode
      else
        #puts productList
        return productList
      end

    end
    #puts productList
    return productList
  end

  def organizePreRollProducts (flowers, prerolls, store, zipcode, budget)
    #puts prerolls
    #puts flowers
    #puts prerolls.count
    prerolls.each do |preroll|
      if preroll["price"].to_f <= budget.to_f
        updateListWithRolls(flowers, preroll, store, zipcode)
      else
        return flowers
      end
    end
    return flowers
  end

  def pushtoList (list, item, store, zipcode)
    length = list.length
    if length == 0
      list.push({ :productname => item["name"], :price => item["price"], :address => store["address"], :city => store["city"], :storeid => store["id"], :storename => store["name"], :thc => item["thc_range"][0], :zipcode=> zipcode, :thc_value => (item["thc_range"][0].to_f / item["price"].to_f) })
    else
      if (item["price"] == list.last[:price])
          if(item["thc_range"][0].to_f > list.last[:thc])
            list[length-1] = { :productname => item["name"], :price => item["price"], :address => store["address"], :city => store["city"], :storeid => store["id"], :storename => store["name"], :thc => item["thc_range"][0], :zipcode=> zipcode, :thc_value => (item["thc_range"][0].to_f / item["price"].to_f) }
          end
      else
          list.push({ :productname => item["name"], :price => item["price"], :address => store["address"], :city => store["city"], :storeid => store["id"], :storename => store["name"], :thc => item["thc_range"][0], :zipcode=> zipcode, :thc_value => (item["thc_range"][0].to_f / item["price"].to_f) })
      end
    end
  end

  def updateListWithRolls(flowers, item, store, zipcode)
    if flowers[0][:price].to_f > item["price"].to_f
      #insert at first
      flowers.insert(0,{ :productname => item["name"], :price => item["price"], :address => store["address"], :city => store["city"], :storeid => store["id"], :storename => store["name"], :thc => item["thc_range"][0], :zipcode=> zipcode, :thc_value => (item["thc_range"][0].to_f / item["price"].to_f) })
      return
    end
    if flowers.last[:price].to_f < item["price"].to_f
      flowers.push({ :productname => item["name"], :price => item["price"], :address => store["address"], :city => store["city"], :storeid => store["id"], :storename => store["name"], :thc => item["thc_range"][0], :zipcode=> zipcode, :thc_value => (item["thc_range"][0].to_f / item["price"].to_f) })
      return
    end
    for i in 0..(flowers.length - 1)
      if (flowers[i][:price] == item["price"])
        flowers[i] = { :productname => item["name"], :price => item["price"], :address => store["address"], :city => store["city"], :storeid => store["id"], :storename => store["name"], :thc => item["thc_range"][0], :zipcode=> zipcode, :thc_value => (item["thc_range"][0].to_f / item["price"].to_f) }
        return
      end
      if (item["price"] > flowers[i][:price] && flowers[i+1][:price] > item["price"])
        flowers.insert(i+1,{ :productname => item["name"], :price => item["price"], :address => store["address"], :city => store["city"], :storeid => store["id"], :storename => store["name"], :thc => item["thc_range"][0], :zipcode=> zipcode, :thc_value => (item["thc_range"][0].to_f / item["price"].to_f) })
        return
      end
    end
  end

end
