require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryBot.create :beer, name: "iso 3", brewery: brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery: brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and the user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end
end

describe "Ratings page" do
  let!(:user) { FactoryBot.create :user }
  let!(:rating1) { FactoryBot.create :rating, score: 20, user: user }
  let!(:rating2) { FactoryBot.create :rating, score: 3, user: user }
  let!(:rating3) { FactoryBot.create :rating, score: 12, user: user }

  it "shows given ratings as averages and their total number" do
    visit ratings_path

    expect(page).to have_content 'Pekka 3'
    expect(page).to have_content 'anonymous 20.0'
    expect(page).to have_content 'anonymous 3.0'
    expect(page).to have_content 'anonymous 12.0'
  end
end
