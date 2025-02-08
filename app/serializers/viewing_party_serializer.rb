class ViewingPartySerializer

  def self.format_viewing_party(viewing_party)
    invitees = viewing_party.user_viewings.where(host: false)
    
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
        invitees.map do |invitee|
              {
                id: invitee.user.id,
                name: invitee.user.name,
                username: invitee.user.username
              }
            end
        }
      }
    }
  end
end