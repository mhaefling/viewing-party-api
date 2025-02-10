class MovieSerializer

  def self.format_movies(movies)
    { data: 
    movies.map do |movie|
      {
        id: movie.id.to_s,
        type: "movie",
        attributes: {
          title: movie.title,
          vote_average: movie.vote_average
        }
      }
    end,
      meta: {
        count: movies.count
      }
    }
  end

  def self.format_detailed_movie(movie)
    { data: {
        id: movie.id.to_s,
        type: "movie",
        attributes: {
          title: movie.title,
          release_year: movie.release_year,
          vote_average: movie.vote_average,
          runtime: movie.display_runtime(movie.runtime),
          genres: movie.display_genres(movie.genres),
          summary: movie.summary,
          cast: movie.display_cast(movie.cast_members),
          total_reviews: movie.total_reviews,
          reviews: movie.display_reviews(movie.reviews)
        }
      }
    }
  end
end