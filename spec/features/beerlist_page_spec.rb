require 'rails_helper'

describe "Beerlist page" do
  before :all do
    Capybara.register_driver :selenium do |app|
      capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
        chromeOptions: { args: ['headless', 'disable-gpu'] }
      )

      Capybara::Selenium::Driver.new app,
        browser: :chrome,
        desired_capabilities: capabilities
    end
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  before :each do
    @brewery1 = FactoryBot.create(:brewery, name:"Koff")
    @brewery2 = FactoryBot.create(:brewery, name:"Schlenkerla")
    @brewery3 = FactoryBot.create(:brewery, name:"Ayinger")
    @style1 = Style.create name:"Lager"
    @style2 = Style.create name:"Rauchbier"
    @style3 = Style.create name:"Weizen"
    @beer1 = FactoryBot.create(:beer, name:"Nikolai", brewery: @brewery1, style:@style1)
    @beer2 = FactoryBot.create(:beer, name:"Fastenbier", brewery:@brewery2, style:@style2)
    @beer3 = FactoryBot.create(:beer, name:"Lechte Weisse", brewery:@brewery3, style:@style3)
  end

  it "shows one known beer", js:true do
    visit beerlist_path
    find('table').find('tr:nth-child(2)')
    expect(page).to have_content "Nikolai"
  end

  it "shows beers alphabetised by name", js:true do
    visit beerlist_path
    first_row = find('table').find('tr:nth-child(2)')
    second_row = find('table').find('tr:nth-child(3)')
    third_row = find('table').find('tr:nth-child(4)')
    expect(first_row).to have_content "Fastenbier"
    expect(second_row).to have_content "Lechte Weisse"
    expect(third_row).to have_content "Nikolai"
  end

  it "when clicked on style, shows beers alphabetised by style", js:true do
    visit beerlist_path
    click_link('style')
    first_row = find('table').find('tr:nth-child(2)')
    second_row = find('table').find('tr:nth-child(3)')
    third_row = find('table').find('tr:nth-child(4)')
    expect(first_row).to have_content "Lager"
    expect(second_row).to have_content "Rauchbier"
    expect(third_row).to have_content "Weizen"
  end

  it "when clicked on brewery, shows beers alphabetised by brewery", js:true do
    visit beerlist_path
    click_link('brewery')
    first_row = find('table').find('tr:nth-child(2)')
    second_row = find('table').find('tr:nth-child(3)')
    third_row = find('table').find('tr:nth-child(4)')
    expect(first_row).to have_content "Ayinger"
    expect(second_row).to have_content "Koff"
    expect(third_row).to have_content "Schlenkerla"
  end
end
