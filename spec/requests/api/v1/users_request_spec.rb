require "rails_helper"

RSpec.describe "Users API", type: :request do

  describe "Create User Endpoint" do
    let(:user_params) do
      {
        name: "Me",
        username: "its_me",
        password: "QWERTY123",
        password_confirmation: "QWERTY123"
      }
    end

    context "request is valid" do
      it "returns 201 Created and provides expected fields" do
        post api_v1_users_path, params: user_params, as: :json

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:type]).to eq("user")
        expect(json[:data][:id]).to eq(User.last.id.to_s)
        expect(json[:data][:attributes][:name]).to eq(user_params[:name])
        expect(json[:data][:attributes][:username]).to eq(user_params[:username])
        expect(json[:data][:attributes]).to have_key(:api_key)
        expect(json[:data][:attributes]).to_not have_key(:password)
        expect(json[:data][:attributes]).to_not have_key(:password_confirmation)
      end
    end

    context "request is invalid" do
      it "returns an error for non-unique username" do
        User.create!(name: "me", username: "its_me", password: "abc123")

        post api_v1_users_path, params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Username has already been taken")
        expect(json[:status]).to eq(400)
      end

      it "returns an error when password does not match password confirmation" do
        user_params = {
          name: "me",
          username: "its_me",
          password: "QWERTY123",
          password_confirmation: "QWERT123"
        }

        post api_v1_users_path, params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Password confirmation doesn't match Password")
        expect(json[:status]).to eq(400)
      end

      it "returns an error for missing field" do
        user_params[:username] = ""

        post api_v1_users_path, params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Username can't be blank")
        expect(json[:status]).to eq(400)
      end
    end
  end

  describe "Get All Users Endpoint" do
    it "retrieves all users but does not share any sensitive data" do
      User.create!(name: "Tom", username: "myspace_creator", password: "test123")
      User.create!(name: "Oprah", username: "oprah", password: "abcqwerty")
      User.create!(name: "Beyonce", username: "sasha_fierce", password: "blueivy")

      get api_v1_users_path

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data].count).to eq(3)
      expect(json[:data][0][:attributes]).to have_key(:name)
      expect(json[:data][0][:attributes]).to have_key(:username)
      expect(json[:data][0][:attributes]).to_not have_key(:password)
      expect(json[:data][0][:attributes]).to_not have_key(:password_digest)
      expect(json[:data][0][:attributes]).to_not have_key(:api_key)
    end
  end

  describe "Get User Profile Details" do
    it "Display detailed User profile with Hosted Viewing Parties and Invited User Parties", :vcr do
      danny = User.create!(name: "Danny DeVito", username: "danny_de_v", password: "jerseyMikesRox7")
      dolly = User.create!(name: "Dolly Parton", username: "dollyP", password: "Jolene123")
      lionel = User.create!(name: "Lionel Messi", username: "futbol_geek", password: "test123")
      matt = User.create!(name: "Matt Haefling", username: "mhaefling", password: "banana")
      jono = User.create!(name: "Jono Sommers", username: "jsommers", password: "pizza")
      natasha = User.create!(name: "Natasha", username: "natashaunwell", password: "sickasadog")
      joe = User.create!(name: "Joe Haefling", username: "jhaefling", password: "wutang")

      party_one_invitees = [joe.id, jono.id]
      party_two_invitees = [matt.id, danny.id]

      party_one = {
        name: "Matts Lord of the rings party",
        start_time: "2025-02-01 10:00:00",
        end_time: "2025-02-01 14:30:00",
        movie_id: 120,
        movie_title: "The Lord of the Rings: The Fellowship of the Ring",
        invitees: party_one_invitees
      }

      party_two = {
        name: "Joes Wu-Tang for life party",
        start_time: "2025-02-01 10:00:00",
        end_time: "2025-02-01 14:30:00",
        movie_id: 96340,
        movie_title: "Wu: The Story of the Wu-Tang Clan",
        invitees: party_two_invitees
      }

      post "/api/v1/users/#{matt.id}/viewing_parties/", params: party_one, as: :json
      post "/api/v1/users/#{joe.id}/viewing_parties/", params: party_two, as: :json

      get "/api/v1/users/#{matt.id}"
      expect(response).to be_successful

      user_profile = JSON.parse(response.body, symbolize_names: true)[:data]
      
      expect(user_profile).to have_key :id
      expect(user_profile[:id]).to be_an(String)
      expect(user_profile[:id]).to eq(matt.id.to_s)

      expect(user_profile).to have_key :type
      expect(user_profile[:type]).to be_an(String)
      expect(user_profile[:type]).to eq("user")

      expect(user_profile).to have_key :attributes
      expect(user_profile[:attributes]).to be_an(Hash)
      expect(user_profile[:attributes]).to have_key :name
      expect(user_profile[:attributes][:name]).to be_an(String)
      expect(user_profile[:attributes][:name]).to eq("Matt Haefling")
      expect(user_profile[:attributes]).to have_key :username
      expect(user_profile[:attributes][:username]).to be_an(String)
      expect(user_profile[:attributes][:username]).to eq("mhaefling")
      
      expect(user_profile[:attributes]).to have_key :viewing_parties_hosted
      expect(user_profile[:attributes][:viewing_parties_hosted]).to be_an(Array)
      
      expect(user_profile[:attributes]).to have_key :viewing_parties_invited
      expect(user_profile[:attributes][:viewing_parties_invited]).to be_an(Array)
    end

    it "Display user profile details even if no parties have been created or invited to user", :vcr do
      danny = User.create!(name: "Danny DeVito", username: "danny_de_v", password: "jerseyMikesRox7")
      dolly = User.create!(name: "Dolly Parton", username: "dollyP", password: "Jolene123")
      lionel = User.create!(name: "Lionel Messi", username: "futbol_geek", password: "test123")
      matt = User.create!(name: "Matt Haefling", username: "mhaefling", password: "banana")
      jono = User.create!(name: "Jono Sommers", username: "jsommers", password: "pizza")
      natasha = User.create!(name: "Natasha", username: "natashaunwell", password: "sickasadog")
      joe = User.create!(name: "Joe Haefling", username: "jhaefling", password: "wutang")

      party_one_invitees = [joe.id, jono.id]
      party_two_invitees = [matt.id, danny.id]

      party_one = {
        name: "Matts Lord of the rings party",
        start_time: "2025-02-01 10:00:00",
        end_time: "2025-02-01 14:30:00",
        movie_id: 120,
        movie_title: "The Lord of the Rings: The Fellowship of the Ring",
        invitees: party_one_invitees
      }

      party_two = {
        name: "Joes Wu-Tang for life party",
        start_time: "2025-02-01 10:00:00",
        end_time: "2025-02-01 14:30:00",
        movie_id: 96340,
        movie_title: "Wu: The Story of the Wu-Tang Clan",
        invitees: party_two_invitees
      }

      post "/api/v1/users/#{matt.id}/viewing_parties/", params: party_one, as: :json
      post "/api/v1/users/#{joe.id}/viewing_parties/", params: party_two, as: :json

      get "/api/v1/users/#{lionel.id}"
      expect(response).to be_successful

      user_profile = JSON.parse(response.body, symbolize_names: true)[:data]
      
      expect(user_profile).to have_key :id
      expect(user_profile[:id]).to be_an(String)
      expect(user_profile[:id]).to eq(lionel.id.to_s)

      expect(user_profile).to have_key :type
      expect(user_profile[:type]).to be_an(String)
      expect(user_profile[:type]).to eq("user")

      expect(user_profile).to have_key :attributes
      expect(user_profile[:attributes]).to be_an(Hash)
      expect(user_profile[:attributes]).to have_key :name
      expect(user_profile[:attributes][:name]).to be_an(String)
      expect(user_profile[:attributes][:name]).to eq("Lionel Messi")
      expect(user_profile[:attributes]).to have_key :username
      expect(user_profile[:attributes][:username]).to be_an(String)
      expect(user_profile[:attributes][:username]).to eq("futbol_geek")
      
      expect(user_profile[:attributes]).to have_key :viewing_parties_hosted
      expect(user_profile[:attributes][:viewing_parties_hosted]).to be_an(Array)
      
      expect(user_profile[:attributes]).to have_key :viewing_parties_invited
      expect(user_profile[:attributes][:viewing_parties_invited]).to be_an(Array)
    end
  end
end
