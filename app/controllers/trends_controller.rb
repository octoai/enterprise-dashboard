require 'octocore'

class TrendsController < ApplicationController

  get '/:trend_for' do
    @enterprise = Octo::Enterprise.first
    @counter_text = counters_text

    erb :trends
  end

  get '/:trend_for/:counter/' do
    @enterprise = Octo::Enterprise.first

    # map for trend texts to corresponding trend classes
    trend_class_map = {
      'categories' => Octo::CategoryTrend,
      'products' => Octo::ProductTrend,
      'tags' => Octo::TagTrend
    }

    # map for trend texts to corresponding counter classes
    counter_map = {
      'categories' => Octo::CategoryHit,
      'products' => Octo::ProductHit,
      'tags' => Octo::TagHit
    }

    trend_clazz = trend_class_map[@params[:trend_for]]
    counter_clazz = counter_map[@params[:trend_for]]

    args = {
      enterprise_id: @enterprise.id,
      type: @params[:counter].to_i
    }
    args = args_with_time(args)

    trends = trend_clazz.send(:where, args)
    counters = counter_clazz.send(:where, args)

    trend_data = trends.collect do |x|
      { rank:  x.rank,
        name: x.uid,
        score: x.score.round(4),
        ts: x.ts
      }
    end

    counter_data = counters.collect do |x|
      {
        total: x.count,
        totalwow: 0.0
      }
    end

    @res = []
    cols = [:ts, :rank, :name, :total, :totalwow, :score]
    trend_data.each_with_index do |t, i|
      x = t.merge(counter_data[i]).values_at(*cols)
      @res << x
    end

    @res.to_json
  end

end

