# Specifications for the Sinatra Assessment

Specs:
- [x] Use Sinatra to build the app

      ApplicationController inherits Sinatra::Base, provides the DSL, library for the app
- [x] Use ActiveRecord for storing information in a database

      ActiveRecord implements assocations between models, essential CRUD methods
- [x] Include more than one model class (list of model class names e.g. User, Post, Category)

      Total of 7 models:
      - Four primary: User, Book, Song, Artwork
      - Three joins: user_books, user_songs, user_artworks
- [x] Include at least one has_many relationship (x has_many y e.g. User has_many Posts)

      - Each primary model `has_many` of each join, and `has_many` users, books, songs, or artwork, `through:` the corresponding join.
- [x] Include user accounts

      A user must "join" the club via a "member" account in order to view app content.  Accounts consist of a username and password
- [x] Ensure that users can't modify content created by other users

      Book, Song, and Artwork models include a `creator_id` attribute; if this attribute doesn't correspond to the ID of the current user, content cannot be modified
- [x] Include user input validations

      Primary models use ActiveRecord validations to prevent saving of "bad" information to database
- [x] Display validation failures to user with error message (example form URL e.g. /posts/new)

      Validation failures implemented as flash messages via the `rack-flash3` gem
- [x] Your README.md includes a short description, install instructions, a contributors guide and a link to the license for your code

Confirm
- [x] You have a large number of small Git commits
- [x] Your commit messages are meaningful
- [x] You made the changes in a commit that relate to the commit message
- [x] You don't include changes in a commit that aren't related to the commit message
