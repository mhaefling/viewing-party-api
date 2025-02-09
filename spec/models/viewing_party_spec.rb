require "rails_helper"

RSpec.describe ViewingParty, type: :model do
  before(:each) do
    User.destroy_all

    @matt_haefling = User.create!(name: "Matt Haefling", username: "mhaefling", password: "banana")
    @jono = User.create!(name: "Jono Sommers", username: "jsommers", password: "pizza")
    @joe_haefling = User.create!(name: "Joe Haefling", username: "jhaefling", password: "wutang")

    @invitees = [@jono.id, @joe_haefling.id]

    @party_details = {
      "name": "Model Test Party",
      "start_time": "2025-02-10 10:00:00",
      "end_time": "2025-02-10 14:30:00",
      "movie_id": 278,
      "movie_title": "The Shawshank Redemption",
      }
  end

  describe "associations" do
    it { should have_many :user_viewings }
    it { should have_many(:users).through(:user_viewings) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }
    it { should validate_presence_of(:movie_id) }
    it { should validate_presence_of(:movie_title) }
  end

  describe "class methods" do
    describe "#create_party" do
      it "creates the party for the host and sets up user viewings for the invitees" do

        new_party = ViewingParty.create_party(@matt_haefling.id, @invitees, @party_details)

        expect(new_party).to be_persisted
        expect(new_party.name).to eq("Model Test Party")
        expect(new_party.users.count).to eq(3)
        expect(new_party.users).to eq([@matt_haefling, @jono, @joe_haefling])
        expect(new_party.users[0].user_viewings[0].host).to eq(true)
        expect(new_party.users[1].user_viewings[0].host).to eq(false)
        expect(new_party.users[2].user_viewings[0].host).to eq(false)
      end
    end

    describe "#validate_viewing_times" do
      it "validates viewing times are not shorter than movie run time", :vcr do

        expect(ViewingParty.validate_viewing_times(@party_details)).to be true
      end

      it "returns 422 error if end time is before start time", :vcr do

        endtime_before_starttime = {
          "name": "Model Test Party",
          "start_time": "2025-02-10 14:30:00",
          "end_time": "2025-02-10 10:00:00",
          "movie_id": 278,
          "movie_title": "The Shawshank Redemption",
        }

        expect{ ViewingParty.validate_viewing_times(endtime_before_starttime)}.to raise_error(StandardError, "Your parties end time cannot be before its start time")
      end

      it "returns 422 error if party duration is shorter than movies run time", :vcr do

        party_duration_to_short = {
          "name": "Model Test Party",
          "start_time": "2025-02-10 10:00:00",
          "end_time": "2025-02-10 10:30:00",
          "movie_id": 278,
          "movie_title": "The Shawshank Redemption",
        }

        expect{ ViewingParty.validate_viewing_times(party_duration_to_short)}.to raise_error(StandardError, "The length of your party, must to be longer than the movies run time")
      end
    end
  end
end