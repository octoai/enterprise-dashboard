class TrendsController < ApplicationController


  get '/products' do

    @counter_text = counters_text
    erb :trends
  end

  get '/categories' do

    @counter_text = counters_text
    erb :trends
  end

  get '/tags' do

    @counter_text = counters_text
    erb :trends
  end

end

