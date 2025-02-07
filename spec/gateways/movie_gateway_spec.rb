require "rails_helper"

RSpec.describe "Movie Gateway" do
  describe 'class methods' do
    it "calls themoviedb for now playing movie data", :vcr do
      movies = MovieGateway.parse_json(MovieGateway.now_playing)
      expect(movies.count).to eq(20)

      movies.each do |movie|
        expect(movie).to have_key :id
        expect(movie[:id]).to be_an(Integer)
        expect(movie).to have_key :original_title
        expect(movie[:original_title]).to be_an(String)
        expect(movie).to have_key :vote_average
        expect(movie[:vote_average]).to be_an(Float)
      end
    end

    it "calls themoviedb for list of 20 top rated movies", :vcr do
      movies = MovieGateway.parse_json(MovieGateway.top_rated)
      expect(movies.count).to eq(20)

      movies.each do |movie|
        expect(movie).to have_key :id
        expect(movie[:id]).to be_an(Integer)
        expect(movie).to have_key :original_title
        expect(movie[:original_title]).to be_an(String)
        expect(movie).to have_key :vote_average
        expect(movie[:vote_average]).to be_an(Float)
      end
    end

    it "calls themoviedb to search movies by keyword(s)", :vcr do
      movies = MovieGateway.parse_json(MovieGateway.search_title("the lord"))
      expect(movies.count).to eq(20)

      movies.each do |movie|
        expect(movie).to have_key :id
        expect(movie[:id]).to be_an(Integer)
        expect(movie).to have_key :original_title
        expect(movie[:original_title]).to be_an(String)
        expect(movie[:original_title].downcase).to include("the", "lord")
        expect(movie).to have_key :vote_average
        expect(movie[:vote_average]).to be_an(Float)
      end
    end

    it "calls themoviedb to search movies by average votes", :vcr do
      movies = MovieGateway.parse_json(MovieGateway.search_votes(3.5))
      expect(movies.count).to eq(20)

      movies.each do |movie|
        expect(movie).to have_key :id
        expect(movie[:id]).to be_an(Integer)
        expect(movie).to have_key :original_title
        expect(movie[:original_title]).to be_an(String)
        expect(movie).to have_key :vote_average
        expect(movie[:vote_average]).to be_an(Float)
        expect(movie[:vote_average]).to be >= 3.5
      end
    end
  end

  describe '.filter', vcr: { record: :new_episodes } do
    context 'when filter param is "top rated"' do
      it 'calls the top_rated method' do
        VCR.use_cassette('top_rated_movies') do
          result = MovieGateway.filter(filter: "top rated")
          expect(result).to be_an(Array)
        end
      end
    end

    context 'when title param is present' do
      it 'calls the search_title method with the correct keyword' do
        VCR.use_cassette('search_movie_inception') do
          result = MovieGateway.filter(title: "Inception")
          expect(result).to be_an(Array)
        end
      end
    end

    context 'when average_votes param is present' do
      it 'calls the search_votes method with the correct vote average' do
        VCR.use_cassette('search_movie_by_votes') do
          result = MovieGateway.filter(average_votes: 8.0)
          expect(result).to be_an(Array)
        end
      end
    end

    context 'when no specific params are passed' do
      it 'calls the now_playing method' do
        VCR.use_cassette('now_playing_movies') do
          result = MovieGateway.filter({})
          expect(result).to be_an(Array)
        end
      end
    end
  end
end