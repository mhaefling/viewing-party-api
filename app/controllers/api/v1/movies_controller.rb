class Api::V1::MoviesController < ApplicationController
  def index
    movies = MovieGateway.filter(params)
    render json: MovieSerializer.format_movies(movies)
  end
end