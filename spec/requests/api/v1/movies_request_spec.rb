require "rails_helper"

RSpec.describe "Movies Endpoint", type: :request do
  describe "happy path" do
    describe "#index" do
      it "can retrieve a list of movies currently playing in theaters", :vcr do
        get "/api/v1/movies"
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
        get "/api/v1/movies?filter=top rated"
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

      it "can retrieve a list of movies by keyword", :vcr do
        keyword1 = "the"
        keyword2 = "lord"

        get "/api/v1/movies?title=#{keyword1} #{keyword2}"
        expect(response).to be_successful
        
        json = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(json.count).to eq(20)

        json.each do |movie|
          expect(movie[:id]).to be_an(String)
          expect(movie[:type]).to eq("movie")
          expect(movie[:attributes]).to have_key(:title)
          expect(movie[:attributes][:title]).to be_an(String)
          expect(movie[:attributes][:title].downcase).to include(keyword1, keyword2)
          expect(movie[:attributes]).to have_key(:vote_average)
          expect(movie[:attributes][:vote_average]).to be_an(Float)
        end
      end

      it "can retrieve a list of movies by average vote", :vcr do
        get "/api/v1/movies?average_votes=5.5"
        expect(response).to be_successful
        
        json = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(json.count).to eq(20)

        json.each do |movie|
          expect(movie[:id]).to be_an(String)
          expect(movie[:type]).to eq("movie")
          expect(movie[:attributes]).to have_key(:title)
          expect(movie[:attributes][:title]).to be_an(String)
          expect(movie[:attributes]).to have_key(:vote_average)
          expect(movie[:attributes][:vote_average]).to be >= 5.5
          expect(movie[:attributes][:vote_average]).to be_an(Float)
        end
      end
    end

    describe "#show" do
      it "can provide a detailed json response of a movie by id", :vcr do
        get "/api/v1/movies/278"
        expect(response).to be_successful

        json = JSON.parse(response.body, symbolize_names: true)[:data]
        
        expect(json).to have_key :id
        expect(json[:id]).to eq("278")
        expect(json).to have_key :type
        expect(json[:type]).to eq("movie")
        expect(json).to have_key :attributes
        expect(json[:attributes]).to have_key :title
        expect(json[:attributes][:title]).to eq("The Shawshank Redemption")
        expect(json[:attributes]).to have_key :release_year
        expect(json[:attributes][:release_year]).to eq(1994)
        expect(json[:attributes]).to have_key :vote_average
        expect(json[:attributes][:vote_average]).to eq(8.708)
        expect(json[:attributes]).to have_key :runtime
        expect(json[:attributes][:runtime]).to eq("2 hours, 22 minutes")
        expect(json[:attributes]).to have_key :genres
        expect(json[:attributes][:genres]).to eq(["Drama", "Crime"])
        expect(json[:attributes]).to have_key :summary
        expect(json[:attributes][:summary]).to eq("Imprisoned in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison, where he puts his accounting skills to work for an amoral warden. During his long stretch in prison, Dufresne comes to be admired by the other inmates -- including an older prisoner named Red -- for his integrity and unquenchable sense of hope.")
        expect(json[:attributes]).to have_key :cast
        expect(json[:attributes][:cast]).to be_an(Array)
        expect(json[:attributes][:cast].count).to eq(10)
        expect(json[:attributes]).to have_key :total_reviews
        expect(json[:attributes][:total_reviews]).to be_an(Integer)
        expect(json[:attributes]).to have_key :reviews
        expect(json[:attributes][:reviews]).to be_an(Array)
        expect(json[:attributes][:reviews].count).to eq(5)
      end
    end
  end
end
