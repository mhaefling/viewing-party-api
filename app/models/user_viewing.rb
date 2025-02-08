class UserViewing < ApplicationRecord
  belongs_to :user
  belongs_to :viewing_party

  validates :viewing_party_id, presence: true
  validates :user_id, presence: true

  before_save :mark_host, if: -> { host.nil? }

  def mark_host
    self.host = viewing_party.user_viewings.empty?
  end
end