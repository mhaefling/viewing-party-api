class Api::V1::MoviesController < ApplicationController
  def index
    movies = MovieGateway.filter(params)
    render json: MovieSerializer.format_movies(movies)
  end

  def show
    movie = MovieGateway.get_movie_details(params[:id])
    render json: MovieSerializer.format_detailed_movie(movie)
  end
end