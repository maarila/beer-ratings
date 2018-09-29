require 'rails_helper'

include Helpers

describe "User" do
  before :each do
    FactoryBot.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Pekka", password: "wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end

    it "when signed up with good credentials, is added to the system" do
      visit signup_path
      fill_in('user_username', with:'Brian')
      fill_in('user_password', with:'Secret55')
      fill_in('user_password_confirmation', with:'Secret55')

      expect{
        click_button('Create User')
      }.to change{User.count}.by(1)
    end
  end
end

describe "User page" do
  let!(:user) { FactoryBot.create :user }
  let!(:rating1) { FactoryBot.create :rating, score: 20, user: user }
  let!(:rating2) { FactoryBot.create :rating, score: 3, user: user }
  let!(:user2) { User.create username: 'Brian', password: 'Secret55', password_confirmation: 'Secret55' }
  let!(:rating4) { FactoryBot.create :rating, score: 1, user: user2 }

  it "when ratings have been given, shows favorite style and brewery" do
    visit user_path(user)

    expect(page).to have_content 'Favourite beer style:'
    expect(page).to have_content 'Favourite brewery:'
  end

  it "when no ratings have been given, does not show favorite style or brewery" do
    user3 = User.create username: "Ounou", password: "Good1", password_confirmation: 'Good1'
    visit user_path(user3)

    expect(page).not_to have_content 'Favourite beer style:'
    expect(page).not_to have_content 'Favourite brewery:'
  end

  it "shows the ratings given by the user" do
    visit user_path(user)

    expect(page).to have_content 'Pekka'
    expect(page).to have_content 'anonymous --> 20'
    expect(page).to have_content 'anonymous --> 3'
  end

  it "does not show ratings given by other users" do
    visit user_path(user)

    expect(page).not_to have_content 'anonymous --> 1'
  end

  it "when delete is clicked for a rating, the rating is removed" do
    sign_in(username: 'Pekka', password: 'Foobar1')
    visit user_path(user)

    page.all('a', text: 'delete')[0].click

    expect(page).not_to have_content 'anonymous --> 20'
    expect(page).to have_content 'anonymous --> 3'
    expect(user.ratings.count).to eq(1)
  end
end
