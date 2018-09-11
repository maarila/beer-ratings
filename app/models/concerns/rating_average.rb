module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    (ratings.map { |r| r.score.to_f }.inject(:+) / ratings.count).round(2)
  end
end
