require 'rails_helper'

RSpec.describe 'movies show page' do
  it 'shows the movie title, creation year, and genre' do
    marvel = Studio.create!(name: 'Marvel', location: 'Denver, CO')

    iron_man = marvel.movies.create!(title: 'Iron Man', creation_year: '2008', genre: 'Action')
    captain_america = marvel.movies.create!(title: 'Captain America', creation_year: '2010', genre: 'Action')
    thor = marvel.movies.create!(title: 'Thor', creation_year: '2011', genre: 'Action')

    visit "/movies/#{iron_man.id}"

    expect(page).to have_content('Iron Man')
    expect(page).to have_content('2008')
    expect(page).to have_content('Action')
  end

  it 'shows actors in order of youngest to oldest' do
    marvel = Studio.create!(name: 'Marvel', location: 'Denver, CO')

    iron_man = marvel.movies.create!(title: 'Iron Man', creation_year: '2008', genre: 'Action')
    captain_america = marvel.movies.create!(title: 'Captain America', creation_year: '2010', genre: 'Action')
    thor = marvel.movies.create!(title: 'Thor', creation_year: '2011', genre: 'Action')

    robertdj = Actor.create!(name: 'Robert Downey Jr.', age: 45)
    sarahjp = Actor.create!(name: 'Sarah Jessica Parker', age: 44)
    jamesc = Actor.create!(name: 'James Cameron', age: 43)

    chris_h = Actor.create!(name: 'Chris Hemsworth', age: 35)

    am1 = ActorMovie.create!(actor_id: robertdj.id, movie_id: iron_man.id)
    am2 = ActorMovie.create!(actor_id: sarahjp.id, movie_id: iron_man.id)
    am3 = ActorMovie.create!(actor_id: jamesc.id, movie_id: iron_man.id)

    am4 = ActorMovie.create!(actor_id: chris_h.id, movie_id: captain_america.id)

    visit "/movies/#{iron_man.id}"
    expect(page).to have_content('Iron Man')
    expect(page).to have_content('2008')
    expect(page).to have_content('Action')

    within('div#actors') do
      expect('James Cameron').to appear_before('Sarah Jessica Parker')
      expect('Sarah Jessica Parker').to appear_before('Robert Downey Jr.')
      expect(page).to_not have_content('Chris Hemsworth')
    end
  end

  it 'shows the average age of actors' do
    marvel = Studio.create!(name: 'Marvel', location: 'Denver, CO')

    iron_man = marvel.movies.create!(title: 'Iron Man', creation_year: '2008', genre: 'Action')
    captain_america = marvel.movies.create!(title: 'Captain America', creation_year: '2010', genre: 'Action')
    thor = marvel.movies.create!(title: 'Thor', creation_year: '2011', genre: 'Action')

    robertdj = Actor.create!(name: 'Robert Downey Jr.', age: 45)
    sarahjp = Actor.create!(name: 'Sarah Jessica Parker', age: 44)
    jamesc = Actor.create!(name: 'James Cameron', age: 43)

    chris_h = Actor.create!(name: 'Chris Hemsworth', age: 35)

    am1 = ActorMovie.create!(actor_id: robertdj.id, movie_id: iron_man.id)
    am2 = ActorMovie.create!(actor_id: sarahjp.id, movie_id: iron_man.id)
    am3 = ActorMovie.create!(actor_id: jamesc.id, movie_id: iron_man.id)

    am4 = ActorMovie.create!(actor_id: chris_h.id, movie_id: captain_america.id)

    visit "/movies/#{iron_man.id}"
    expect(page).to have_content('Iron Man')
    expect(page).to have_content('2008')
    expect(page).to have_content('Action')

    within('div#actors') do
      expect('James Cameron').to appear_before('Sarah Jessica Parker')
      expect('Sarah Jessica Parker').to appear_before('Robert Downey Jr.')
      expect(page).to_not have_content('Chris Hemsworth')
    end

    expect(page).to have_content('Average Age of Actors:')
    expect(page).to have_content(44)
  end

  it 'can add actors to a movie' do
    marvel = Studio.create!(name: 'Marvel', location: 'Denver, CO')

    iron_man = marvel.movies.create!(title: 'Iron Man', creation_year: '2008', genre: 'Action')
    captain_america = marvel.movies.create!(title: 'Captain America', creation_year: '2010', genre: 'Action')
    thor = marvel.movies.create!(title: 'Thor', creation_year: '2011', genre: 'Action')

    robertdj = Actor.create!(name: 'Robert Downey Jr.', age: 45)
    sarahjp = Actor.create!(name: 'Sarah Jessica Parker', age: 44)
    jamesc = Actor.create!(name: 'James Cameron', age: 43)

    johnn = Actor.create!(name: 'John Newman', age: 35)
    chris_h = Actor.create!(name: 'Chris Hemsworth', age: 35)

    am1 = ActorMovie.create!(actor_id: robertdj.id, movie_id: iron_man.id)
    am2 = ActorMovie.create!(actor_id: sarahjp.id, movie_id: iron_man.id)
    am3 = ActorMovie.create!(actor_id: jamesc.id, movie_id: iron_man.id)

    am4 = ActorMovie.create!(actor_id: chris_h.id, movie_id: captain_america.id)

    visit "/movies/#{iron_man.id}"

    within('div#actors') do
      expect('James Cameron').to appear_before('Sarah Jessica Parker')
      expect('Sarah Jessica Parker').to appear_before('Robert Downey Jr.')
      expect(page).to_not have_content('Chris Hemsworth')
    end

    fill_in :name, with: 'John Newman'

    click_on('Submit')
    expect(current_path).to eq("/movies/#{iron_man.id}")
    within('div#actors') do
      expect('James Cameron').to appear_before('Sarah Jessica Parker')
      expect('Sarah Jessica Parker').to appear_before('Robert Downey Jr.')
      expect(page).to_not have_content('Chris Hemsworth')
      expect(page).to have_content('John Newman')
    end
  end
end
