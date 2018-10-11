class Style < ApplicationRecord
  has_many :beers

  def average_rating
    beer_averages = beers.map(&:average_rating).select(&:positive?)
    beer_averages.inject(:+).to_f / beer_averages.size
  end

  def self.top(amount)
    sorted_by_rating_in_desc_order = Style.all.sort_by{ |s| -(s.average_rating || 0) }
    sorted_by_rating_in_desc_order[0...amount]
  end
end
