require 'rails_helper'

RSpec.describe Beer, type: :model do
  describe "with a proper brewery" do
    let(:brewery) { Brewery.create name: "Test Brewery", year: "2018" }
    let(:style) { Style.create name: "Lager", description: "Great!" }

    it "is created and saved when name and style is provided" do
      beer = Beer.create name: "WedBuiser", style: style, brewery: brewery

      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
    end

    it "is not saved without a name" do
      beer = Beer.create style: style, brewery: brewery

      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end

    it "is not saved without a style" do
      beer = Beer.create name: "WedBuiser", brewery: brewery

      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end
  end
end
