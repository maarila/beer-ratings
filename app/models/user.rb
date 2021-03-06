class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true,
                       length: { minimum: 3,
                                 maximum: 30 }
  validates :password, length: { minimum: 4 },
                       format: { with: /\w*((?:[A-Z]\w*[0-9])|(?:[0-9]\w*[A-Z]))\w*/,
                                 message: "requires one capital letter and one number" }

  has_many :ratings, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :beer_clubs, through: :memberships

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    ratings = Rating.joins(:user).where(user_id: id).joins(:beer).group(:style_id).average(:score)
    style_id = ratings.max_by { |_style, score| score }.first
    Style.find_by id: style_id
  end

  def favorite_brewery
    return nil if ratings.empty?

    ratings = Rating.joins(:user).where(user_id: id).joins(:beer).group(:brewery_id).average(:score)
    brewery_id = ratings.max_by { |_style, score| score }.first
    favorite = Brewery.find_by id: brewery_id
    favorite.name
  end

  def self.active(amount)
    sorted_by_number_of_ratings_in_desc_order = User.all.sort_by{ |b| -(b.ratings.count || 0) }
    sorted_by_number_of_ratings_in_desc_order[0...amount]
  end
end
