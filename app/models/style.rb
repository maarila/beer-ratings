class Style < ApplicationRecord
  extend Top

  has_many :beers

  def average_rating
    beer_averages = beers.map(&:average_rating).select(&:positive?)
    beer_averages.inject(:+).to_f / beer_averages.size
  end
end
