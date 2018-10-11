class Brewery < ApplicationRecord
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, numericality: { only_integer: true }
  validate :year_is_between_1040_and_current_year

  scope :active, -> { where active: true }
  scope :retired, -> { where active: [nil, false] }

  def year_is_between_1040_and_current_year
    errors.add(:year, "needs to be between 1040 and #{Time.now.year}") if year < 1040 || year > Time.now.year
  end

  def print_report
    puts name
    puts "Established at year #{year}"
    puts "Number of beers: #{beers.count}"
  end

  def restart
    self.year = 2018
    puts "Changed year to #{year}"
  end

  def self.top(amount)
    sorted_by_rating_in_desc_order = Brewery.all.sort_by{ |b| -(b.average_rating || 0) }
    sorted_by_rating_in_desc_order[0...amount]
  end
end
