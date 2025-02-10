require "rails_helper"

RSpec.describe "Movie PORO" do
  describe "initialize" do
    it "creates a movie PORO", :vcr do
      movie = MovieGateway.get_movie_details(278)
      
      expect(movie).to be_an_instance_of Movie

      expect(movie.id).to be_an(Integer)
      expect(movie.id).to eq(278)
      expect(movie.title).to be_an(String)
      expect(movie.title).to eq("The Shawshank Redemption")
      expect(movie.release_year).to be_an(Integer)
      expect(movie.release_year).to eq(1994)
      expect(movie.vote_average).to be_an(Float)
      expect(movie.runtime).to be_an(Integer)
      expect(movie.runtime).to eq(142)
      expect(movie.genres).to be_an(Array)
      expect(movie.genres).to eq([{:id=>18, :name=>"Drama"}, {:id=>80, :name=>"Crime"}])
      expect(movie.summary).to be_an(String)
      expect(movie.summary).to eq("Imprisoned in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison, where he puts his accounting skills to work for an amoral warden. During his long stretch in prison, Dufresne comes to be admired by the other inmates -- including an older prisoner named Red -- for his integrity and unquenchable sense of hope.")
      expect(movie.cast_members).to be_an(Array)
      expect(movie.cast_members[0]).to have_key :character
      expect(movie.cast_members[0]).to have_key :name
      expect(movie.total_reviews).to be_an(Integer)
      expect(movie.reviews).to be_an(Array)
    end
  end

  describe "instance methods" do
    describe "#display_genres" do
      it "iterates through the genres array to pull out the names of each genre", :vcr do
        movie = MovieGateway.get_movie_details(278)

        expect(movie.display_genres(movie.genres)).to eq(["Drama", "Crime"])
      end
    end

    describe "#display_cast" do
      it "iterates through the cast members and display the first 10's name and character", :vcr do
        movie = MovieGateway.get_movie_details(278)

        expect(movie.display_cast(movie.cast_members).count).to eq(10)
        expect(movie.display_cast(movie.cast_members)).to eq([
          {
              "character": "Andy Dufresne",
              "actor": "Tim Robbins"
          },
          {
              "character": "Ellis Boyd 'Red' Redding",
              "actor": "Morgan Freeman"
          },
          {
              "character": "Warden Norton",
              "actor": "Bob Gunton"
          },
          {
              "character": "Heywood",
              "actor": "William Sadler"
          },
          {
              "character": "Captain Byron T. Hadley",
              "actor": "Clancy Brown"
          },
          {
              "character": "Tommy",
              "actor": "Gil Bellows"
          },
          {
              "character": "Brooks Hatlen",
              "actor": "James Whitmore"
          },
          {
              "character": "Bogs Diamond",
              "actor": "Mark Rolston"
          },
          {
              "character": "1946 D.A.",
              "actor": "Jeffrey DeMunn"
          },
          {
              "character": "Skeet",
              "actor": "Larry Brandenburg"
          }
      ])
      end
    end

    describe "#display_reviews" do
      it "iterates through the movies reviews and displays the first 5's author and review content", :vcr do
        movie = MovieGateway.get_movie_details(278)

        expect(movie.display_reviews(movie.reviews).count).to eq(5)
        expect(movie.display_reviews(movie.reviews)).to eq([
          {
              "author": "elshaarawy",
              "review": "very good movie 9.5/10 محمد الشعراوى"
          },
          {
              "author": "John Chard",
              "review": "Some birds aren't meant to be caged.\r\n\r\nThe Shawshank Redemption is written and directed by Frank Darabont. It is an adaptation of the Stephen King novella Rita Hayworth and Shawshank Redemption. Starring Tim Robbins and Morgan Freeman, the film portrays the story of Andy Dufresne (Robbins), a banker who is sentenced to two life sentences at Shawshank State Prison for apparently murdering his wife and her lover. Andy finds it tough going but finds solace in the friendship he forms with fellow inmate Ellis \"Red\" Redding (Freeman). While things start to pick up when the warden finds Andy a prison job more befitting his talents as a banker. However, the arrival of another inmate is going to vastly change things for all of them.\r\n\r\nThere was no fanfare or bunting put out for the release of the film back in 94, with a title that didn't give much inkling to anyone about what it was about, and with Columbia Pictures unsure how to market it, Shawshank Redemption barely registered at the box office. However, come Academy Award time the film received several nominations, and although it won none, it stirred up interest in the film for its home entertainment release. The rest, as they say, is history. For the film finally found an audience that saw the film propelled to almost mythical proportions as an endearing modern day classic. Something that has delighted its fans, whilst simultaneously baffling its detractors. One thing is for sure, though, is that which ever side of the Shawshank fence you sit on, the film continues to gather new fans and simply will never go away or loose that mythical status.\r\n\r\nIt's possibly the simplicity of it all that sends some haters of the film into cinematic spasms. The implausible plot and an apparent sentimental edge that makes a nonsense of prison life, are but two chief complaints from those that dislike the film with a passion. Yet when characters are this richly drawn, and so movingly performed, it strikes me as churlish to do down a human drama that's dealing in hope, friendship and faith. The sentimental aspect is indeed there, but that acts as a counterpoint to the suffering, degradation and shattering of the soul involving our protagonist. Cosy prison life you say? No chance. The need for human connection is never more needed than during incarceration, surely? And given the quite terrific performances of Robbins (never better) & Freeman (sublimely making it easy), it's the easiest thing in the world to warm to Andy and Red.\r\n\r\nThose in support aren't faring too bad either. Bob Gunton is coiled spring smarm as Warden Norton, James Whitmore is heart achingly great as the \"Birdman Of Shawshank,\" Clancy Brown is menacing as antagonist Capt. Byron Hadley, William Sadler amusing as Heywood & Mark Rolston is impressively vile as Bogs Diamond. Then there's Roger Deakins' lush cinematography as the camera gracefully glides in and out of the prison offering almost ethereal hope to our characters (yes, they are ours). The music pings in conjunction with the emotional flow of the movie too. Thomas Newman's score is mostly piano based, dovetailing neatly with Andy's state of mind, while the excellently selected soundtrack ranges from the likes of Hank Williams to the gorgeous Le Nozze di Figaro by Mozart.\r\n\r\nIf you love Shawshank then it's a love that lasts a lifetime. Every viewing brings the same array of emotions - anger - revilement - happiness - sadness - inspiration and a warmth that can reduce the most hardened into misty eyed wonderment. Above all else, though, Shawshank offers hope - not just for characters in a movie - but for a better life and a better world for all of us. 10/10"
          },
          {
              "author": "tmdb73913433",
              "review": "Make way for the best film ever made people. **Make way.**"
          },
          {
              "author": "thommo_nz",
              "review": "There is a reason why this movie is at the top of any popular list your will find.\r\nVery strong performances from lead actors and a story line from the literary brilliance of Stephen King (and no, its not a horror).\r\nSufficient drama and depth to keep you interested and occupied without stupefying your brain. It is the movie that has something for everyone."
          },
          {
              "author": "Andrew Gentry",
              "review": "It's still puzzling to me why this movie exactly continues to appear in every single best-movies-of-all-time chart. There's a great story, perfect cast, and acting. It really moves me in times when I'm finding myself figuring out things with my annual tax routine reading <a href=\"https://www.buzzfeed.com/davidsmithjd/what-is-form-w-2-and-how-does-it-work-3n31d\">this article</a>, and accidentally catching myself wondering what my life should be if circumstances had changed so drastically. This movie worth a rewatch by all means, but yet, there's no unique vibe or something - there are thousands of other ones as good as this one."
          }
      ])
      end
    end

    describe "#display_runtime" do
      it "converts the movies integer run time into a string with hours and mintes", :vcr do
        movie = MovieGateway.get_movie_details(278)

        expect(movie.display_runtime(movie.runtime)).to eq("2 hours, 22 minutes")
      end
    end
  end
end