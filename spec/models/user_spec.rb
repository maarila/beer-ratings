require 'rails_helper'

include Helpers

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with a too short password" do
    user = User.create username:"Pekka", password: "Se1", password_confirmation: "Se1"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved if password is missing numbers" do
    user = User.create username:"Pekka", password: "Secret", password_confirmation: "Secret"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "favorite beer" do
    let(:user) { FactoryBot.create(:user) }

    it "has method for determining the favorite beer" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have a favorite beer" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_many_ratings( { user: user }, 10, 20, 15, 7, 9 )
      best = create_beer_with_rating( { user: user }, 25 )

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user) { FactoryBot.create(:user) }

    it "has method for determining favorite style" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_style).to eq("lager")
    end

    it "is the one with the highest rating average if several rated" do
      brewery = FactoryBot.create(:brewery)
      beer1 = FactoryBot.create(:beer)
      beer2 = FactoryBot.create(:beer)
      beer3 = Beer.new name: "SuperBeer", style: "IPA", brewery: brewery
      rating1 = FactoryBot.create(:rating, score: 20, beer: beer1, user: user)
      rating2 = FactoryBot.create(:rating, score: 10, beer: beer2, user: user)
      rating3 = FactoryBot.create(:rating, score: 50, beer: beer3, user: user)

      expect(user.favorite_style).to eq("IPA")
    end
  end

  describe "favorite brewery" do
    let(:user) { FactoryBot.create(:user) }

    it "has method for determining favorite brewery" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_brewery).to eq("anonymous")
    end

    it "is the one with the highest rating average if several rated" do
      brewery = FactoryBot.create(:brewery)
      super_brewery = Brewery.new name: "SuperBrewery", year: "1975"
      beer1 = FactoryBot.create(:beer)
      beer2 = FactoryBot.create(:beer)
      beer3 = Beer.new name: "SuperBeer", style: "IPA", brewery: super_brewery
      rating1 = FactoryBot.create(:rating, score: 20, beer: beer1, user: user)
      rating2 = FactoryBot.create(:rating, score: 10, beer: beer2, user: user)
      rating3 = FactoryBot.create(:rating, score: 50, beer: beer3, user: user)

      expect(user.favorite_brewery).to eq("SuperBrewery")
    end
  end

  describe "with a proper password" do
    let(:user) { FactoryBot.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end
end
