class MovieGateway

  def self.top_rated
    response = conn.get("/3/movie/top_rated")
    JSON.parse(response.body, symbolize_names: true)
  end

  private

  def self.conn
    Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.headers["Authorization"] = Rails.application.credentials.themoviedb[:key]
    end
  end
end