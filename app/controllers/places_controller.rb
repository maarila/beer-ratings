class PlacesController < ApplicationController
  before_action :set_place, only: [:show]

  def index
  end

  def search
    Rails.cache.write("last_searched_city", params[:city], expires_in: 3.days)
    @places = BeermappingApi.places_in(params[:city])
    @weather = BeermappingApi.weather_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No places in #{params[:city]}"
    else
      render :index
    end
  end

  def set_place
    places = Rails.cache.read(Rails.cache.read("last_searched_city"))
    @place = places.select { |place| place.id == params[:id] }
  end
end
