class Movie
  attr_reader :id,
              :title,
              :vote_average,
              :release_year,
              :runtime,
              :generes,
              :summary,
              :cast_members,
              :total_reviews,
              :review

  def initialize(movie)
    @id = movie[:id]
    @title = movie[:original_title]
    @vote_average = movie[:vote_average]
    @release_year = movie[:release_date][0..3].to_i
    @runtime = movie[:runtime] #This will need to be updated based on 2nd EP's JSON key
    @generes = movie[:genre_ids] ##This will need to be updated based on 2nd EP's JSON key
    @summary = movie[:overview]
    @cast_members = movie[:cast_members] ##This will need to be updated based on 2nd EP's JSON key
    @total_reviews = movie[:vote_count] ##This will need to be updated based on 2nd EP's JSON key
    @review = movie[:reviews] ##This will need to be updated based on 2nd EP's JSON key
  end
end