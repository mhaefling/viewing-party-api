require "rails_helper"

RSpec.describe "ViewingParty Endpoint", type: :request do

  before(:each) do
    User.destroy_all

    @matt_haefling = User.create!(name: "Matt Haefling", username: "mhaefling", password: "banana")
    @jono = User.create!(name: "Jono Sommers", username: "jsommers", password: "pizza")
    @joe_haefling = User.create!(name: "Joe Haefling", username: "jhaefling", password: "wutang")
    @natasha_vasquez = User.create!(name: "Natasha Vasquez", username: "nvasquez", password: "notfeelinggood")
    @phyllis_haefling = User.create!(name: "Phyllis Haefling", username: "phaefling", password: "homesweethome")
  end

  describe "happy path" do
    describe "#create" do
      it "creates a new viewing party", :vcr do

        invitees = [@jono.id, @joe_haefling.id]

        body = {
          name: "Cohort 24010 Viewing Party",
          start_time: "2025-02-10 10:00:00",
          end_time: "2025-02-10 14:30:00",
          movie_id: 278,
          movie_title: "The Shawshank Redemption",
          invitees: invitees
        }

        post "/api/v1/users/#{@matt_haefling.id}/viewing_parties", params: body, as: :json
        expect(response).to be_successful
        expect(response.status).to eq(200)

        new_party = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(new_party).to have_key :id
        expect(new_party[:id]).to be_a(String)

        expect(new_party).to have_key :type
        expect(new_party[:type]).to be_a(String)
        expect(new_party[:type]).to eq("viewing_party")

        expect(new_party).to have_key :attributes
        expect(new_party[:attributes]).to be_a(Hash)

        expect(new_party[:attributes]).to have_key :name
        expect(new_party[:attributes][:name]).to be_a(String)
        expect(new_party[:attributes][:name]).to eq("Cohort 24010 Viewing Party")

        expect(new_party[:attributes]).to have_key :start_time
        expect(new_party[:attributes][:start_time]).to be_a(String)
        expect(new_party[:attributes][:start_time]).to eq("2025-02-10 10:00:00")

        expect(new_party[:attributes]).to have_key :end_time
        expect(new_party[:attributes][:end_time]).to be_a(String)
        expect(new_party[:attributes][:end_time]).to eq("2025-02-10 14:30:00")

        expect(new_party[:attributes]).to have_key :movie_id
        expect(new_party[:attributes][:movie_id]).to be_a(Integer)
        expect(new_party[:attributes][:movie_id]).to eq(278)

        expect(new_party[:attributes]).to have_key :movie_title
        expect(new_party[:attributes][:movie_title]).to be_a(String)
        expect(new_party[:attributes][:movie_title]).to eq("The Shawshank Redemption")

        expect(new_party[:attributes]).to have_key :invitees
        expect(new_party[:attributes][:invitees]).to be_a(Array)
        expect(new_party[:attributes][:invitees].count).to eq(2)
        expect(new_party[:attributes][:invitees].first).to eq({ id: @jono.id, name: @jono.name, username: @jono.username})
        expect(new_party[:attributes][:invitees].last).to eq({ id: @joe_haefling.id, name: @joe_haefling.name, username: @joe_haefling.username})
      end
      
      it "creates a viewing party even if invalid invitees were provided", :vcr do
        invitees = [@jono.id, @joe_haefling.id, 900000, 200000]
    
        body = {
          name: "Cohort 24010 Viewing Party",
          start_time: "2025-02-10 10:00:00",
          end_time: "2025-02-10 14:30:00",
          movie_id: 278,
          movie_title: "The Shawshank Redemption",
          invitees: invitees
        }
    
        post "/api/v1/users/#{@matt_haefling.id}/viewing_parties", params: body, as: :json
        expect(response).to be_successful
        expect(response.status).to eq(200)
    
        new_party = JSON.parse(response.body, symbolize_names: true)[:data]
    
        expect(new_party[:attributes][:invitees].count).to eq(2)
        expect(new_party[:attributes][:invitees].first).to eq({ id: @jono.id, name: @jono.name, username: @jono.username})
        expect(new_party[:attributes][:invitees].last).to eq({ id: @joe_haefling.id, name: @joe_haefling.name, username: @joe_haefling.username})
      end

      it "creates a viewing party even if extra attributes were provided", :vcr do
        invitees = [@jono.id, @joe_haefling.id]
    
        body = {
          name: "Cohort 24010 Viewing Party",
          start_time: "2025-02-10 10:00:00",
          end_time: "2025-02-10 14:30:00",
          movie_id: 278,
          movie_title: "The Shawshank Redemption",
          rando: "I don't need this attribute",
          invitees: invitees
        }
    
        post "/api/v1/users/#{@matt_haefling.id}/viewing_parties", params: body, as: :json
        expect(response).to be_successful
        expect(response.status).to eq(200)
      end
    end

    describe "#update" do
      it "Adds a new invitee to an existing viewing party", :vcr do
        invitees = [@jono.id, @joe_haefling.id]

        body = {
          name: "Cohort 24010 Viewing Party",
          start_time: "2025-02-10 10:00:00",
          end_time: "2025-02-10 14:30:00",
          movie_id: 278,
          movie_title: "The Shawshank Redemption",
          invitees: invitees
        }

        post "/api/v1/users/#{@matt_haefling.id}/viewing_parties", params: body, as: :json
        new_party = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(new_party[:attributes][:invitees].count).to eq(2)
        expect(new_party[:attributes][:invitees].first).to eq({ id: @jono.id, name: @jono.name, username: @jono.username})
        expect(new_party[:attributes][:invitees].last).to eq({ id: @joe_haefling.id, name: @joe_haefling.name, username: @joe_haefling.username})

        new_invitee = @phyllis_haefling.id

        update_request = {
          invitees_user_id: new_invitee
        }

        patch "/api/v1/users/#{@matt_haefling.id}/viewing_parties/#{new_party[:id].to_i}", params: update_request, as: :json
        updated_party = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(updated_party[:attributes][:invitees].count).to eq(3)
        expect(updated_party[:attributes][:invitees][0]).to eq({ id: @jono.id, name: @jono.name, username: @jono.username})
        expect(updated_party[:attributes][:invitees][1]).to eq({ id: @joe_haefling.id, name: @joe_haefling.name, username: @joe_haefling.username})
        expect(updated_party[:attributes][:invitees][2]).to eq({ id: @phyllis_haefling.id, name: @phyllis_haefling.name, username: @phyllis_haefling.username})
      end
    end
  end

  describe "sad path" do
    describe "#create" do
      it "returns 422 error when host is an invalid user id", :vcr do

        invitees = [@jono.id, @joe_haefling.id]

        body = {
          name: "Cohort 24010 Viewing Party",
          start_time: "2025-02-10 10:00:00",
          end_time: "2025-02-10 14:30:00",
          movie_id: 278,
          movie_title: "The Shawshank Redemption",
          invitees: invitees
        }

        post "/api/v1/users/30000/viewing_parties", params: body, as: :json
        expect(response.status).to eq(422)

        error = JSON.parse(response.body, symbolize_names: true)
        expect(error).to have_key :message
        expect(error[:message]).to eq("Couldn't find User with 'id'=30000")
        expect(error).to have_key :status
        expect(error[:status]).to eq(422)
      end

      it "returns 422 when required attributes are missing or blank", :vcr do

        invitees = [@jono.id, @joe_haefling.id]

        body = {
          name: "Cohort 24010 Viewing Party",
          start_time: "2025-02-10 10:00:00",
          movie_id: 278,
          movie_title: "The Shawshank Redemption",
          invitees: invitees
        }

        post "/api/v1/users/#{@matt_haefling.id}/viewing_parties", params: body, as: :json
        expect(response.status).to eq(422)

        error = JSON.parse(response.body, symbolize_names: true)
        expect(error).to have_key :message
        expect(error[:message]).to eq("Validation failed: End time can't be blank")
        expect(error).to have_key :status
        expect(error[:status]).to eq(422)
      end

      it "returns 422 when party length is less than the movie run time", :vcr do
        invitees = [@jono.id, @joe_haefling.id]

        body = {
          name: "Cohort 24010 Viewing Party",
          start_time: "2025-02-10 10:00:00",
          end_time: "2025-02-10 10:30:00",
          movie_id: 278,
          movie_title: "The Shawshank Redemption",
          invitees: invitees
        }

        post "/api/v1/users/#{@matt_haefling.id}/viewing_parties", params: body, as: :json
        expect(response.status).to eq(422)

        error = JSON.parse(response.body, symbolize_names: true)
        expect(error).to have_key :message
        expect(error[:message]).to eq("The length of your party, must to be longer than the movies run time")
        expect(error).to have_key :status
        expect(error[:status]).to eq(422)
      end

      it "returns 422 when parties end time is before its start time", :vcr do
        invitees = [@jono.id, @joe_haefling.id]

        body = {
          name: "Cohort 24010 Viewing Party",
          start_time: "2025-02-10 14:30:00",
          end_time: "2025-02-10 10:00:00",
          movie_id: 278,
          movie_title: "The Shawshank Redemption",
          invitees: invitees
        }

        post "/api/v1/users/#{@matt_haefling.id}/viewing_parties", params: body, as: :json
        expect(response.status).to eq(422)

        error = JSON.parse(response.body, symbolize_names: true)
        expect(error).to have_key :message
        expect(error[:message]).to eq("Your parties end time cannot be before its start time")
        expect(error).to have_key :status
        expect(error[:status]).to eq(422)
      end
    end

    describe "#update" do
      it "returns 422 when viewing party id is invalid", :vcr do
        invitees = [@jono.id, @joe_haefling.id]

        body = {
          name: "Cohort 24010 Viewing Party",
          start_time: "2025-02-10 10:00:00",
          end_time: "2025-02-10 14:30:00",
          movie_id: 278,
          movie_title: "The Shawshank Redemption",
          invitees: invitees
        }

        post "/api/v1/users/#{@matt_haefling.id}/viewing_parties", params: body, as: :json
        new_party = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(new_party[:attributes][:invitees].count).to eq(2)
        expect(new_party[:attributes][:invitees].first).to eq({ id: @jono.id, name: @jono.name, username: @jono.username})
        expect(new_party[:attributes][:invitees].last).to eq({ id: @joe_haefling.id, name: @joe_haefling.name, username: @joe_haefling.username})

        new_invitee = @phyllis_haefling.id

        update_request = {
          invitees_user_id: new_invitee
        }

        patch "/api/v1/users/#{@matt_haefling.id}/viewing_parties/4000000", params: update_request, as: :json
        error = JSON.parse(response.body, symbolize_names: true)
        expect(error).to have_key :message
        expect(error[:message]).to eq("Couldn't find ViewingParty with 'id'=4000000")
        expect(error).to have_key :status
        expect(error[:status]).to eq(422)
      end

      it "returns 422 when invitee id is invalid", :vcr do
        invitees = [@jono.id, @joe_haefling.id]

        body = {
          name: "Cohort 24010 Viewing Party",
          start_time: "2025-02-10 10:00:00",
          end_time: "2025-02-10 14:30:00",
          movie_id: 278,
          movie_title: "The Shawshank Redemption",
          invitees: invitees
        }

        post "/api/v1/users/#{@matt_haefling.id}/viewing_parties", params: body, as: :json
        new_party = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(new_party[:attributes][:invitees].count).to eq(2)
        expect(new_party[:attributes][:invitees].first).to eq({ id: @jono.id, name: @jono.name, username: @jono.username})
        expect(new_party[:attributes][:invitees].last).to eq({ id: @joe_haefling.id, name: @joe_haefling.name, username: @joe_haefling.username})

        new_invitee = 70000

        update_request = {
          invitees_user_id: new_invitee
        }

        patch "/api/v1/users/#{@matt_haefling.id}/viewing_parties/#{new_party[:id].to_i}", params: update_request, as: :json
        error = JSON.parse(response.body, symbolize_names: true)
        expect(error).to have_key :message
        expect(error[:message]).to eq("Couldn't find User with 'id'=70000")
        expect(error).to have_key :status
        expect(error[:status]).to eq(422)
      end
    end
  end
end