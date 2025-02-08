class ViewingPartySerializer

  def self.format_viewing_party(viewing_party)
    people = User.joins(:user_viewings).where(user_viewings: {host: false})

    { data: {
        id: viewing_party.id.to_s,
        type: "viewing_party",
        attributes: {
          name: viewing_party.name,
          start_time: viewing_party.start_time,
          end_time: viewing_party.end_time,
          movie_id: viewing_party.movie_id,
          movie_title: viewing_party.movie_title,
          invitees:
            people.map do |person|
              {
                id: person.id,
                name: person.name,
                username: person.username
              }
            end
        }
      }
    }
  end
end