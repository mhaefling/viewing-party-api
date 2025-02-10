require "rails_helper"

RSpec.describe UserViewing, type: :model do
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
    it { should belong_to :user }
    it { should belong_to :viewing_party }
  end

  describe "validations" do
    it { should validate_presence_of(:viewing_party_id) }
    it { should validate_presence_of(:user_id) }
  end

  describe "class methods" do
    describe "#create_invitee_viewings" do
      it "creates entries on the joins table for invitees to a new viewing party" do

        host = @matt_haefling
        new_party = host.viewing_parties.create!(@party_details)
        UserViewing.create_invitee_viewings(@invitees, new_party)

        expect(new_party.user_viewings[1].user_id).to eq(@jono.id)
        expect(new_party.user_viewings[1].viewing_party_id).to eq(new_party.id)
        expect(new_party.user_viewings[2].user_id).to eq(@joe_haefling.id)
        expect(new_party.user_viewings[2].viewing_party_id).to eq(new_party.id)
      end
    end

    describe "#mark_host" do
      it "marks the creater of new viewing parties as the host" do
        host = @matt_haefling
        new_party = host.viewing_parties.create!(@party_details)
        UserViewing.create_invitee_viewings(@invitees, new_party)
        
        expect(new_party.user_viewings[0].user_id).to eq(@matt_haefling.id)
        expect(new_party.user_viewings[0].viewing_party_id).to eq(new_party.id)
        expect(new_party.user_viewings[0].host).to eq(true)
        expect(@matt_haefling.user_viewings[0].mark_host).to eq(false)
      end
    end
  end
end