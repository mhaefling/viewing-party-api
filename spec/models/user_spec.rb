require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many :user_viewings }
    it { should have_many(:viewing_parties).through(:user_viewings) }
  end
  
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_presence_of(:password) }
    it { should have_secure_password }
    it { should have_secure_token(:api_key) }
  end

  describe "class methods" do
    describe "validate_invitees" do
      it "returns an array of valid invitee id's from an array of invitee id's" do
        phyllis_haefling = User.create!(name: "Phyllis Haefling", username: "phaefling", password: "scrapple")
        steve_haefling = User.create!(name: "Steve Haefling", username: "shaefling", password: "moonshine")
        deloras_haefling = User.create!(name: "Deloras Haefling", username: "dhaefling", password: "icecream")

        invitees = [phyllis_haefling.id, steve_haefling.id, deloras_haefling.id, 40, 500, 6000, 70000]

        expect(User.validate_invitees(invitees)).to eq([phyllis_haefling.id, steve_haefling.id, deloras_haefling.id])
      end
    end
  end
end