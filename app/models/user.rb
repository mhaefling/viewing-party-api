class User < ApplicationRecord
  validates :name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: { require: true }
  has_secure_password
  has_secure_token :api_key
  has_many :user_viewings
  has_many :viewing_parties, through: :user_viewings

#   attr_reader :viewing_parties_hosted,
#               :viewing_parties_invited

# def initialize(user)
#   @viewing_parties_hosted = viewing_parties.where(host: true)
#   @viewing_parties_invited = viewing_parties.where(host: false)
# end

  def self.validate_invitees(invitees)
    valid_invitees = [] 
    invitees.each do |invitee|
      if User.find_by(id: invitee)
        valid_invitees << invitee
      end
    end
    return valid_invitees
  end
end