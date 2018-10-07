require 'rails_helper'

include Helpers

describe "Beer" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:style) { FactoryBot.create :style }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "is saved when a valid name is given" do
    visit new_beer_path
    fill_in('beer_name', with: 'Test Beer')
    select('Koff', from: 'beer[brewery_id]')
    select('Lager', from: 'beer[style_id]')

    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(1)
  end

  it "is not saved and an error message is shown with invalid name" do
    visit new_beer_path
    select('Koff', from: 'beer[brewery_id]')
    click_button('Create Beer')

    expect(page).to have_content 'Name can\'t be blank'
    expect(Beer.count).to be(0)
  end
end
