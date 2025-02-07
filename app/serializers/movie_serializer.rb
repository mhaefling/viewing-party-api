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
end