require "rails_helper"

RSpec.describe "Movie Gateway" do
  describe 'class methods' do
    describe "#filter" do
      it "calls themoviedb for now playing movie data", :vcr do
        params = {}
        movies = MovieGateway.filter(params)
        expect(movies.count).to eq(20)

        movies.each do |movie|
          expect(movie).to respond_to(:id)
          expect(movie.id).to be_an(Integer)
          expect(movie).to respond_to(:title)
          expect(movie.title).to be_an(String)
          expect(movie).to respond_to(:vote_average)
          expect(movie.vote_average).to be_an(Float)
        end
      end

      it "calls themoviedb for list of 20 top rated movies", :vcr do
        movies = MovieGateway.filter(filter: "top rated")
        expect(movies.count).to eq(20)

        movies.each do |movie|
          expect(movie).to respond_to(:id)
          expect(movie.id).to be_an(Integer)
          expect(movie).to respond_to(:title)
          expect(movie.title).to be_an(String)
          expect(movie).to respond_to(:vote_average)
          expect(movie.vote_average).to be_an(Float)
        end
      end

      it "calls themoviedb to search movies by keyword(s)", :vcr do
        movies = MovieGateway.filter(title: "the lord")
        expect(movies.count).to eq(20)

        movies.each do |movie|
          expect(movie).to respond_to(:id)
          expect(movie.id).to be_an(Integer)
          expect(movie).to respond_to(:title)
          expect(movie.title).to be_an(String)
          expect(movie.title.downcase).to include("the", "lord")
          expect(movie).to respond_to(:vote_average)
          expect(movie.vote_average).to be_an(Float)
        end
      end

      it "calls themoviedb to search movies by average votes", :vcr do
        movies = MovieGateway.filter(average_votes: 3.5)
        expect(movies.count).to eq(20)
  
        movies.each do |movie|
          expect(movie).to respond_to(:id)
          expect(movie.id).to be_an(Integer)
          expect(movie).to respond_to(:title)
          expect(movie.title).to be_an(String)
          expect(movie).to respond_to(:vote_average)
          expect(movie.vote_average).to be_an(Float)
          expect(movie.vote_average).to be >= 3.5
        end
      end
    end

    describe "#now_playing" do
      it "confirms themoviedb responded to now playing movie request", :vcr do
        json_response = JSON.parse(MovieGateway.now_playing.body, symbolize_names: true)[:results]

        expect(json_response).to be_an(Array)
        expect(json_response.count).to eq(20)
        expect(json_response.sample).to have_key :id
        expect(json_response.sample[:id]).to be_an(Integer)
        expect(json_response.sample).to have_key :original_title
        expect(json_response.sample[:original_title]).to be_an(String)
        expect(json_response.sample).to have_key :vote_average
        expect(json_response.sample[:vote_average]).to be_an(Float)
      end
    end

    describe "#top_rated" do
      it "confirms themoviedb responded to top rated movie request", :vcr do
        json_response = JSON.parse(MovieGateway.top_rated.body, symbolize_names: true)[:results]

        expect(json_response).to be_an(Array)
        expect(json_response.count).to eq(20)
        expect(json_response.sample).to have_key :id
        expect(json_response.sample[:id]).to be_an(Integer)
        expect(json_response.sample).to have_key :original_title
        expect(json_response.sample[:original_title]).to be_an(String)
        expect(json_response.sample).to have_key :vote_average
        expect(json_response.sample[:vote_average]).to be_an(Float)
      end
    end

    describe "#search_title" do
      it "confirms themoviedb responded to keyword movie searches", :vcr do
        json_response = JSON.parse(MovieGateway.search_title("the lord").body, symbolize_names: true)[:results]

        expect(json_response).to be_an(Array)
        expect(json_response.count).to eq(20)
        expect(json_response.sample).to have_key :id
        expect(json_response.sample[:id]).to be_an(Integer)
        expect(json_response.sample).to have_key :original_title
        expect(json_response.sample[:original_title]).to be_an(String)
        expect(json_response.sample[:original_title].downcase).to include("the", "lord")
        expect(json_response.sample).to have_key :vote_average
        expect(json_response.sample[:vote_average]).to be_an(Float)
      end
    end

    describe "#search_votes" do
      it "confirms themoviedb responded to average vote movie search", :vcr do
        json_response = JSON.parse(MovieGateway.search_votes(5.3).body, symbolize_names: true)[:results]

        expect(json_response).to be_an(Array)
        expect(json_response.count).to eq(20)
        expect(json_response.sample).to have_key :id
        expect(json_response.sample[:id]).to be_an(Integer)
        expect(json_response.sample).to have_key :original_title
        expect(json_response.sample[:original_title]).to be_an(String)
        expect(json_response.sample).to have_key :vote_average
        expect(json_response.sample[:vote_average]).to be_an(Float)
        expect(json_response.sample[:vote_average]).to be >= 5.3
      end
    end

    describe "#get_general_data" do
      it "confirms themoviedb '3/movie/{movie_id}' responded to movie search by movie id", :vcr do
        json_response = MovieGateway.get_general_data(278)

        expect(json_response).to be_an(Hash)
        expect(json_response).to have_key :id
        expect(json_response[:id]).to be_an(Integer)
        expect(json_response).to have_key :original_title
        expect(json_response[:original_title]).to be_an(String)
        expect(json_response).to have_key :release_date
        expect(json_response[:release_date]).to be_an(String)
        expect(json_response).to have_key :vote_average
        expect(json_response[:vote_average]).to be_an(Float)
        expect(json_response).to have_key :runtime
        expect(json_response[:runtime]).to be_an(Integer)
        expect(json_response).to have_key :genres
        expect(json_response[:genres]).to be_an(Array)
        expect(json_response).to have_key :overview
        expect(json_response[:overview]).to be_an(String)
      end
    end

    describe "#get_crew_data" do
      it "confirms themoviedb '3/movie/{movie_id}/credits' responded to movie search by movie id", :vcr do
        json_response = MovieGateway.get_crew_data(278)[:cast]

        expect(json_response).to be_an(Array)
        expect(json_response.sample).to have_key :character
        expect(json_response.sample[:character]).to be_an(String)
        expect(json_response.sample).to have_key :name
        expect(json_response.sample[:name]).to be_an(String)
      end
    end

    describe "#get_review_data" do
      it "confirms themoviedb 'https://api.themoviedb.org/3/movie/{movie_id}/reviews' responded to movie search by movie id", :vcr do
        json_response = MovieGateway.get_review_data(278)[:results]

        expect(json_response).to be_an(Array)
        expect(json_response.sample).to have_key :author
        expect(json_response.sample[:author]).to be_an(String)
        expect(json_response.sample).to have_key :content
        expect(json_response.sample[:content]).to be_an(String)
      end
    end
    
    describe "#movie_run_time" do
      it "calls themoviedb to get run time of a specific movie by id", :vcr do
        expect(MovieGateway.movie_run_time(278)).to eq(142)
      end
    end

    describe "#get_movie_details" do
      it "calls themoviedb hitting three different endpoints to create a detailed movie", :vcr do
        movie = MovieGateway.get_movie_details(278)

        expect(movie).to be_an Movie
        expect(movie).to respond_to(:id)
        expect(movie.id).to be_an(Integer)
        expect(movie).to respond_to(:title)
        expect(movie.title).to be_an(String)
        expect(movie).to respond_to(:release_year)
        expect(movie.release_year).to be_an(Integer)
        expect(movie).to respond_to(:vote_average)
        expect(movie.vote_average).to be_an(Float)
        expect(movie).to respond_to(:runtime)
        expect(movie.runtime).to be_an(Integer)
        expect(movie).to respond_to(:genres)
        expect(movie.genres).to be_an(Array)
        expect(movie).to respond_to(:summary)
        expect(movie.summary).to be_an(String)
        expect(movie).to respond_to(:cast_members)
        expect(movie.cast_members).to be_an(Array)
        expect(movie).to respond_to(:total_reviews)
        expect(movie.total_reviews).to be_an(Integer)
        expect(movie).to respond_to(:reviews)
        expect(movie.reviews).to be_an(Array)
      end
    end
  end
end