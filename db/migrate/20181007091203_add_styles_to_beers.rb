class AddStylesToBeers < ActiveRecord::Migration[5.2]
  def up
    beers = Beer.all
    beers.each do |beer|
      beer.style_id = Style.find_by(name: beer.old_style).id
      beer.save
    end
  end

  def down
    beers = Beer.all
    beers.each do |beer|
      beer.style_id = nil
      beer.save
    end
  end
end
