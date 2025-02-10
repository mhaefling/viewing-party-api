# Viewing Part API
    - Viewing Party Solo Project for Module 3 in Turing's Software Engineering Program. 

    - A Ruby on Rails API that allows you to pull movie data from an external API called [The Movie Database](https://www.themoviedb.org/).  You can then use this information to create viewing parties with scheduled start and end times and invite your friends to those parties. You can also view your user profile to look at the parties you're the host of and have been invited to.

## How to Install:
    ### Requirements:
        - Ruby 3.2.2
        - Rails 7.1.4 or Newer
        - (PostgreSQL) 14.14 or Newer
    ### Installation Instructions:
        - create a directory on your local computer where you would like to keep this project:
            Example: `/Users/username/Turing/Mod3/projects/`
        - Use the following command to clone this repository:
            `git@github.com:mhaefling/viewing-party-api.git`
        - Change into the projects directory:
            `cd viewing-party-api`
        - Run the following setup commmands
            `bundle install`
            `rails db:{drop,create,migrate,seed}`
            `rails s` or `rails server`

## Running Tests

    - Gateways:
        `bundle exec rspec /spec/gateways`
    - Models:
        `bundle exec rspec /spec/models`
    - PORO's:
        `bundle exec rspec /spec/poros`
    - Requests:
        `bundle exec rspec /spec/requests/api/v1`

## How to Use:
    ### After you have the rails server running, you can use "Postman" application to make end point requests at the followings paths:

    - User Index - Returns a list of all the current users in the database:
        GET `/api/v1/users/`
```
    {
        "data": [
            {
                "id": "1",
                "type": "user",
                "attributes": {
                    "name": "Danny DeVito",
                    "username": "danny_de_v"
            }
        }
    ]
}
```
    - Add User - Allows you to create a new user in the database:
        POST `/api/v1/users/`

```{
    "name": "Users Name",
    "username": "newuser",
    "password": "password"
}
```

    - Detailed User Profile - Returns the list of all the parties you're hosting and all the parties you were invited to.
        GET `/api/v1/users/4`

```
{
    "data": {
        "id": "4",
        "type": "user",
        "attributes": {
            "name": "Matt Haefling",
            "username": "mhaefling",
            "viewing_parties_hosted": [
                {
                    "id": 1,
                    "name": "Matts Lord of the rings party",
                    "start_time": "2025-02-01 10:00:00",
                    "end_time": "2025-02-01 14:30:00",
                    "movie_id": 120,
                    "movie_title": "The Lord of the Rings: The Fellowship of the Ring",
                    "host_id": 4
                }
            ],
            "viewing_parties_invited": [
                {
                    "name": "Jono's Die Hard Party",
                    "start_time": "2025-02-10 10:00:00",
                    "end_time": "2025-02-10 14:30:00",
                    "movie_id": 562,
                    "movie_title": "Die Hard",
                    "id": 5
                },
                {
                    "name": "Joes WuTang for life party!",
                    "start_time": "2025-02-20 10:00:00",
                    "end_time": "2025-02-20 14:30:00",
                    "movie_id": 96340,
                    "movie_title": "Wu: The Story of the Wu-Tang Clan",
                    "id": 7
                }
            ]
        }
    }
}
```
    - Now Playing Movies - Returns a list of all the movies that are currently playing in theater
        GET `/api/v1/movies/`

    - Top Rated Movies - Returns a list of the top 20 rated movies
        GET `/api/v1/movies?filter=top rated`
    
    - Search Movie titles by keyword - Returns a list of 20 movies containing the keyword you search for
        GET `/api/v1/movies?title=the lord`

    - Search Movies by average votes - Returns a list of 20 movies that have an average vote greater than or equal to your request
        GET `/api/v1/movies?average_votes=4.0`

    - Search for Movie details based on Movie ID - Returns detailed information about the movie you requested, including the Actors and their Characters and movie Reviews.
        GET `/api/v1/movies/<movie_id>`

    - Create Viewing Party - Allows you to create a new viewing party, with specific invitees
        POST `/api/v1/users/<hosts_user_id>/viewing_parties`

```
{
  "name": "Matts Lord of the rings party",
  "start_time": "2025-02-01 10:00:00",
  "end_time": "2025-02-01 14:30:00",
  "movie_id": 120,
  "movie_title": "The Lord of the Rings: The Fellowship of the Ring",
  "invitees": [7, 5, 8] // !!! PLEASE NOTE INVITEES USER_ID'S MUST BE PROVIDED WITHIN AN ARRAY
}
```
    - Adding Invitee to Existing Viewing Party - Allows you to update an existing viewing party with a new invitee
        PATCH `/v1/users/<hosts_user_id>/viewing_parties/<party_id>

```
{
  "invitees_user_id": 2
}
```

## Development Tool Used:
    - VSCode
    - Postman
    - Ruby 3.2.2
    - Rails 7.1.4
    - (PostgreSQL) 14.14

### Ruby Gems:
    - Pry
    - RSpec-Rails
    - Should-Matachers
    - pgreset
    - faraday
    - jsonapi-serializer
    - simplecov
    - webmock
    - vcr

# Author

- Matt Haefling
- [LinkedIn](www.linkedin.com/in/matthew-haefling)
- [Github](https://github.com/mhaefling)
