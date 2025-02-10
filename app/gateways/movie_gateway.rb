class MovieGateway

  def self.now_playing
    conn.get("/3/movie/now_playing")
  end
  
  def self.top_rated
    conn.get("/3/movie/top_rated")
  end

  def self.search_title(keyword)
    conn.get("/3/search/movie?query=#{keyword}")
  end

  def self.search_votes(average)
    conn.get("/3/discover/movie?vote_average.gte=#{average}")
  end

  def self.movie_run_time(movie_id)
    JSON.parse(conn.get("/3/movie/#{movie_id}").body, symbolize_names: true)[:runtime]
  end

  def self.get_movie_details(movie_id)
    general = get_general_data(movie_id)
    crew = get_crew_data(movie_id)
    review = get_review_data(movie_id)
    create_detailed_movie_structure(general, crew, review)
  end

  def self.get_general_data(movie_id)
    JSON.parse(conn.get("/3/movie/#{movie_id}").body, symbolize_names: true)
  end

  def self.get_crew_data(movie_id)
    JSON.parse(conn.get("3/movie/#{movie_id}/credits").body, symbolize_names: true)
  end
  
  def self.get_review_data(movie_id)
    JSON.parse(conn.get("3/movie/#{movie_id}/reviews").body, symbolize_names: true)
  end

  def self.create_detailed_movie_structure(general, crew, review)
    movie = {
      id: general[:id],
      original_title: general[:original_title],
      release_date: general[:release_date],
      vote_average: general[:vote_average],
      runtime: general[:runtime],
      genres: general[:genres],
      overview: general[:overview],
      cast: crew[:cast],
      total_reviews: review[:total_results],
      reviews: review[:results]
    }
    Movie.new(movie)
  end

  private

  def self.conn
    Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.headers["Authorization"] = Rails.application.credentials.themoviedb[:key]
    end
  end

  def self.parse_json(response)
    JSON.parse(response.body, symbolize_names: true)[:results]
  end

  def self.filter(search_params)

    if search_params.include?(:filter) && search_params[:filter] == "top rated"
      create_movie_poro(parse_json(top_rated))

    elsif search_params.include?(:title)
      create_movie_poro(parse_json(search_title(search_params[:title])))

    elsif search_params.include?(:average_votes)
      create_movie_poro(parse_json(search_votes(search_params[:average_votes])))

    else
      create_movie_poro(parse_json(now_playing))
    end
  end

  def self.create_movie_poro(movies)
    movies.map do |movie|
      Movie.new(movie)
    end
  end

end