# About The Finer Things Club

The Finer Things Club is a Sinatra-built web app based on the original _ Finer Things Club _ that debuted in Season 4, Episode 6 of _ The Office _ (US).  This app is a tribute of sorts to Pam's, Oscar's, and Toby's interest to celebrate the arts "in a very civilized way" with "no paper, no plastic, and no work talk allowed"  (see ** License ** for more info).

After signing up, a user can create and manage a collection of fine art, music, and books.  Users can also view all such entries to the database supporting the app; future versions will include the ability to identify users with similar interests.

The Finer Things Club app was created to meet requirements of Learn.co's Sinatra Portfolio Project; these requirements are listed in `spec.md`.

## Install instructions

To install, clone or fork this repository, then run `bundle install` from the terminal prompt.

## Usage

To create a new verison of the database, populate it with seed data, and get started, run the following commands from the terminal prompt:

```ruby
$ rake db:rollback STEP=11
$ rake db:migrate db:seed
$ shotgun
```
Then, in your browser, navigate to `localhost:9393`.  User names and passwords for the seeded data can be found in `db/seeds.rb`.  The app's models, associations, and seed data can be directly accessed and manipulated via `tux` or `rake console`.

## Contributions

Bug reports and pull requests are welcome on GitHub at https://github.com/christinalcole/sinatra-finer-things. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

This project is available as open source under the terms of the [MIT License](opensource.org/licenses/MIT).

_The Office_ is a NBC production.  This web app is not affiliated with or endorsed by NBC, and no rights associated with the production have been transferred.
