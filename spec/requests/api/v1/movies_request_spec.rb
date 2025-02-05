require "rails_helper"

RSpec.describe "Movies Endpoint" do
  describe "happy path" do
    it "can retrieve a list of 20 most top rated movies", :vcr do
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
  end
end