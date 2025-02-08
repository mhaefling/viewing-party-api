require "rails_helper"

RSpec.describe "Movie PORO" do
  it "creates a movie from JSON response data" do
    sample_movie_json = {:adult=>false,
    :backdrop_path=>"/zOpe0eHsq0A2NvNyBbtT6sj53qV.jpg",
    :genre_ids=>[28, 878, 35, 10751],
    :id=>939243,
    :original_language=>"en",
    :original_title=>"Sonic the Hedgehog 3",
    :overview=>"Sonic, Knuckles, and Tails reunite against a powerful new adversary, Shadow, a mysterious villain with powers unlike anything they have faced before. With their abilities outmatched in every way, Team Sonic must seek out an unlikely alliance in hopes of stopping Shadow and protecting the planet.",
    :popularity=>3264.78,
    :poster_path=>"/d8Ryb8AunYAuycVKDp5HpdWPKgC.jpg",
    :release_date=>"2024-12-19",
    :title=>"Sonic the Hedgehog 3",
    :video=>false,
    :vote_average=>7.8,
    :vote_count=>1553}

    movie = Movie.new(sample_movie_json)
    expect(movie).to be_an_instance_of Movie

    expect(movie.id).to eq(sample_movie_json[:id])
    expect(movie.title).to eq(sample_movie_json[:original_title])
    expect(movie.vote_average).to eq(sample_movie_json[:vote_average])
    expect(movie.release_year.to_s).to eq(sample_movie_json[:release_date][0..3])
    expect(movie.summary).to eq(sample_movie_json[:overview])
  end
end