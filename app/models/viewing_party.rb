class ViewingParty < ApplicationRecord
  validates :name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :movie_id, presence: true, numericality: { only_integer: true }
  validates :movie_title, presence: true

  has_many :user_viewings
  has_many :users, through: :user_viewings

  def self.create_party(host_user, invitees, party_details)
      host = User.find(host_user)
      new_party = host.viewing_parties.create!(party_details)

      invitees.each do |invitee|
        UserViewing.create(user: User.find(invitee), viewing_party: new_party, host: false)
      end

      return new_party
  end

  def self.check_viewing_times(movie_details)
    if movie_details[:movie_id] != nil
      movie_runtime = MovieGateway.movie_run_time(movie_details[:movie_id])
      start_time = movie_details[:start_time][11..-4].delete":"
      end_time = movie_details[:end_time][11..-4].delete":"
      party_length = end_time.to_i - start_time.to_i
      if party_length < movie_runtime
        raise StandardError, "Party length has to be longer than movies run time"
      end
    end
  end
end