require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [Place.new(name: "Oljenkorsi", id: 1)]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if several are returned by the API, they are all shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [Place.new(name: "Oljenkorsi", id: 1), Place.new(name: "Kaljalandia", id: 2), Place.new(name: "Ohrala", id: 3)]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
    expect(page).to have_content "Kaljalandia"
    expect(page).to have_content "Ohrala"
  end

  it "if none are found, a notification is shown to the user" do
    allow(BeermappingApi).to receive(:places_in).with("kampusla").and_return(
      []
    )

    visit places_path
    fill_in('city', with: 'kampusla')
    click_button "Search"
    save_and_open_page

    expect(page).to have_content "No places in kampusla"
  end
end
