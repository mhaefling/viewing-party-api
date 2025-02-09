class ViewingParty < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :movie_id, presence: true, numericality: { only_integer: true }
  validates :movie_title, presence: true

  has_many :user_viewings
  has_many :users, through: :user_viewings

  def self.create_party(host, invitees, party_details)
      new_party = host.viewing_parties.create!(party_details)
      UserViewing.create_invitee_viewings(invitees, new_party)
      return new_party
  end

  def self.validate_viewing_times(movie_details)
    if movie_details[:movie_id] != nil && movie_details[:start_time] != nil && movie_details[:end_time] != nil
      movie_runtime = MovieGateway.movie_run_time(movie_details[:movie_id])

      start_time = movie_details[:start_time][11..-4].delete":"
      end_time = movie_details[:end_time][11..-4].delete":"

      party_length = end_time.to_i - start_time.to_i

      if movie_details[:start_time] >= movie_details[:end_time]
        raise StandardError, "Your parties end time cannot be before its start time"
      elsif party_length < movie_runtime
        raise StandardError, "The length of your party, must to be longer than the movies run time"
      else
        return true
      end
      
    end
  end
end