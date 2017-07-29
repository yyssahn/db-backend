class SearchController < ApplicationController
  include Response
  def json
    puts 'dd'
    render html: '<h1>dd<h1>'

  end
end
