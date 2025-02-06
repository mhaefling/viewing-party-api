require "rails_helper"

RSpec.describe "Movies Endpoint" do
  describe "happy path" do
    it "can retrieve a list of movies currently playing in theaters", :vcr do
      get '/api/v1/movies'
      expect(response).to be_successful
      
      json = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(json.count).to eq(20)

      json.each do |movie|
        expect(movie[:id]).to be_an(String)
        expect(movie[:type]).to eq("movie")
        expect(movie[:attributes]).to have_key(:title)
        expect(movie[:attributes][:title]).to be_an(String)
        expect(movie[:attributes]).to have_key(:vote_average)
        expect(movie[:attributes][:vote_average]).to be_an(Float)
      end
    end

    it "can retrieve a list of the 20 top rated movies", :vcr do
      get '/api/v1/movies?filter=top rated'
      expect(response).to be_successful
      
      json = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(json.count).to eq(20)

      json.each do |movie|
        expect(movie[:id]).to be_an(String)
        expect(movie[:type]).to eq("movie")
        expect(movie[:attributes]).to have_key(:title)
        expect(movie[:attributes][:title]).to be_an(String)
        expect(movie[:attributes]).to have_key(:vote_average)
        expect(movie[:attributes][:vote_average]).to be > 8
        expect(movie[:attributes][:vote_average]).to be_an(Float)
      end
    end
  end
end