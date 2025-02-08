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
end