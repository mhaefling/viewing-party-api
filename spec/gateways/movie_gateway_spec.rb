require "rails_helper"

RSpec.describe "Movie Gateway" do
  describe 'class methods' do
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

    it "calls themoviedb to get run time of a specific movie by id", :vcr do
      expect(MovieGateway.movie_run_time(278)).to eq(142)
      
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
end