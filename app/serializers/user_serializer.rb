class UserSerializer
  include JSONAPI::Serializer
  attributes :name, :username, :api_key

  def self.format_user_list(users)
    { data:
        users.map do |user|
          {
            id: user.id.to_s,
            type: "user",
            attributes: {
              name: user.name,
              username: user.username
            }
          }
        end
    }
  end

  def self.format_user_details(user)
    { data: 
    {
      id: user.id.to_s,
      type: "user",
      attributes: {
        name: user.name,
        username: user.username,
        viewing_parties_hosted: 
        user.viewing_parties.joins(:user_viewings).where(user_viewings: { host: true }).distinct.map do |viewing|
          {
            id: viewing.id,
            name: viewing.name,
            start_time: viewing.start_time.to_s[0..18],
            end_time: viewing.end_time.to_s[0..18],
            movie_id: viewing.movie_id,
            movie_title: viewing.movie_title,
            host_id: user.id
          }
        end,
        viewing_parties_invited:
        user.viewing_parties.joins(:user_viewings).where(user_viewings: { host: false }).distinct.map do |viewing|
          {
            name: viewing.name,
            start_time: viewing.start_time.to_s[0..18],
            end_time: viewing.end_time.to_s[0..18],
            movie_id: viewing.movie_id,
            movie_title: viewing.movie_title,
            id: viewing.user_viewings.where(host: true)[0].user_id
          }
        end
      }
    }
  }
  end
end