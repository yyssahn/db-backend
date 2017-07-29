class SearchController < ApplicationController
  include Response
  def json
    puts params[:zipcode]
    puts params[:budget]
    render html: '<h1>dd<h1>'

  end
end
