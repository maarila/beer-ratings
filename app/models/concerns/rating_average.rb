module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    return 0 if ratings.empty?

    (ratings.map { |r| r.score.to_f }.inject(:+) / ratings.count).round(1)
  end
end
