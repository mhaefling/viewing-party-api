class Api::V1::MoviesController < ApplicationController
  def index
    top_rated = MovieGateway.top_rated
    render json: MovieSerializer.format_movies(top_rated)
  end
end