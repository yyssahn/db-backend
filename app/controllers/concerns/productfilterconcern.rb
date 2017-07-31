module Productfilterconcern

  def getHighestTHC(totalProductList, budget)

    filteredList = [];
    totalProductList.each do | productList |
      temp = productList.shift
      budget -= temp[:price]
      puts budget
      filteredList.push(temp)

    end
    while budget > 0
      temp = findMaxValue totalProductList
      if (budget - temp[:price]) < 0
          break
      else
          filteredList.push(temp)
          budget -= temp[:price]
          puts budget
      end
    end
      puts filteredList
      return filteredList
  end

  def findMaxValue (totalProductList)
    max = totalProductList[0][0]
    maxPosition = 0
    for i in 0..(totalProductList.length - 1)
      if not (totalProductList[i].empty?)
        if(totalProductList[i][0][:thc_value] > max[:thc_value])
          max = totalProductList[i][0]
          maxPosition = i
        end
      end
    end
    return totalProductList[maxPosition].shift()
  end
end
