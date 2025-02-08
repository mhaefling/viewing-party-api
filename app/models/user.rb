class User < ApplicationRecord
  validates :name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: { require: true }
  has_secure_password
  has_secure_token :api_key
  has_many :user_viewings
  has_many :viewing_parties, through: :user_viewings

  def self.validate_all_users(host, invitees)
    if find(host)
      invitees.each do |invitee|
        find(invitee)
      end
    end
  end
end