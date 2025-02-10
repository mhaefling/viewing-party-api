class Movie
  attr_reader :id,
              :title,
              :vote_average,
              :release_year,
              :runtime,
              :genres,
              :summary,
              :cast_members,
              :total_reviews,
              :reviews

  def initialize(movie)
    @id = movie[:id]
    @title = movie[:original_title]
    @release_year = movie[:release_date][0..3].to_i
    @vote_average = movie[:vote_average]
    @runtime = movie[:runtime]
    @genres = movie[:genres]
    @summary = movie[:overview]
    @cast_members = movie[:cast]
    @total_reviews = movie[:total_reviews]
    @reviews = movie[:reviews]
  end

  def display_genres(movie_genres)
    genres = []
    movie_genres.each do |genre|
      genres << genre[:name]
    end
    return genres
  end

  def display_cast(movie_cast)
    cast = [] 
    movie_cast.each do |member|
      cast << { character: member[:character], actor: member[:name]}
    end
    return cast[0..9]
  end

  def display_reviews(review_data)
    reviews = []
    review_data.each do |review|
      reviews << { author: review[:author], review: review[:content] }
    end
    return reviews[0..4]
  end

  def display_runtime(runtime)
    hours = runtime / 60
    minutes = runtime % 60
    return "#{hours} hours, #{minutes} minutes"
  end
end