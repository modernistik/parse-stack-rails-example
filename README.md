# Rails Application with Parse-Server Example
This is a sample application is used to showcase how to integrate a [Rails](https://github.com/rails/rails) application with a [Parse-Server](https://github.com/ParsePlatform/parse-server) backend through the use of the [Parse-Stack](https://github.com/modernistik/parse-stack) gem.

## Getting Started
Make sure you have your API keys for your Parse-Server handy. To get started, clone this repo and run the bundle command.

    $ bundle install

Edit the [`config/initializers/parse.rb`](https://github.com/modernistik/parse-server-rails-example/blob/master/config/initializers/parse.rb) file so that it is configured with your Parse-Server API keys. You may optionally use a `.env` file that will be loaded into your `ENV`.

```
# in .env
PARSE_SERVER_URL=https://api.parse.com/1
PARSE_APP_ID=<YOUR_APP_ID>
PARSE_API_KEY=<YOUR_API_ID>
PARSE_MASTER_KEY=<YOUR_MASTER_KEY>
```

We have created a sample `Song` and `Artist` model in the [`apps/models` directory](https://github.com/modernistik/parse-server-rails-example/tree/master/app/models). To upgrade your schema and create these new collections, run the `parse:upgrade` task.

    $ rails parse:upgrade

To seed your collections with sample content, run the `db:seed` task. See [seeds.rb](https://github.com/modernistik/parse-server-rails-example/blob/master/db/seeds.rb).

    $ rails db:seed

You are ready to go! Try running the `rails console` command and perform a few queries.

```ruby
    artist = Artist.first
    Song.count( :released.after => 1965 ) # 2
    song = Song.first(artist: artist)
    song.artist.name
    song.name = "My New Title"
    song.save
```

## Build Your Own
You can start a brand new Rails application with Parse-Server integration. First create a new rails app with your preferred options. In this example, we will skip `Active::Record` since we will use Parse-Server as our database backend.

    $ rails new parse-server-example --skip-active-record

Next, add this line to your Gemfile:

    gem 'parse-stack'

And then execute:

    $ bundle

Now, install the Parse-Stack configuration:

    $ rails g parse_stack:install

This will create a configuration file (`config/initializers/parse.rb`) and a set of sample models and hooks under app/models directory. Modify `config/initializers/parse.rb` file with **your Parse-Server API keys**. Once that is completed, you can use the Parse-Stack generator to generate sample models:

    $ rails g parse_stack:model Song name:string released:integer genres:array
    $ rails g parse_stack:model Artist name:string

You should now see the new models you just generated in the `app/models` directory. To upgrade your Parse-Server schema to include these new models, run the `parse:upgrade` task.

    $ rails parse:upgrade

You should now see two new collections created in your Parse-Server backend `Artist` and `Song`. You can now use the [documented API](https://github.com/modernistik/parse-stack) to create new objects and perform queries using Parse-Stack.
