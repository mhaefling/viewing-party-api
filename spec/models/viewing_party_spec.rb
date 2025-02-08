require "rails_helper"

RSpec.describe ViewingParty, type: :model do
  describe "validations" do
    it { should have_many :user_viewings }
    it { should have_many(:users).through(:user_viewings) }
  end
end