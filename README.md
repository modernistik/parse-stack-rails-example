# Parse Server Rails Application Example
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

### Model Generators
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

### Cloud Code Webhooks
You can have the Rails application handle cloud code functions and triggers. As an example, there is a sample `helloWorld` cloud code method in `app/models/webhooks.rb`. The code should look similar to:

```ruby
# create a route for a function called 'helloWorld'
Parse::Webhooks.route :function, :helloWorld do
  name = params['name'].to_s # function params
  name.present? ? "Hello #{name}!" : "Hello World!"
end
```

Because we are going to be running other endpoints on this Rails application, we will set all Parse-Server webhooks go to our server on the mount path of `/webhooks` (you can change it). We will then set a Rails route for the `Parse::Webhooks` rack handler to `/webhooks`. Edit the `routes.rb`:

```ruby
# in routes.rb
Rails.application.routes.draw do
  # All incoming Cloud Code webhooks will be at this mount path
  mount Parse::Webhooks, :at => '/webhooks'
end
```

We will test having this Rails application handle the logic when someone calls the function `helloWorld` through the Parse-Server. To do this, we will use [`ngrok`](https://ngrok.com) to provide us with a public facing url where we can receive our request from Parse-Server. Open a separate terminal, install ngrok and start it on the rails default port.

    $ brew install homebrew/binary/ngrok2 # OSX
    $ ngrok http 3000

This should start the ngrok proxy and assign you a specific url (ex. https://12345678.ngrok.io) pointing to http://localhost:3000. We will now set our `HOOKS_URL` environment variable to this assigned ngrok url with our mount path: (ex. `HOOKS_URL=https://12345678.ngrok.io/webhooks`) . You can now register the webhooks with your Parse-Server by using the helper task `rails parse:webhooks:register`. _Depending where you finally decide you put your models you may have to set `config.eager_load = true` in `development.rb`._

```bash
$ HOOKS_URL=https://12345678.ngrok.io/webhooks \
rails parse:webhooks:register

Registering Parse Webhooks @ https://12345678.ngrok.io/webhooks
[+] function - helloWorld
```

Now you can start your rails server in production (for eager loading):

```bash
  $ rails s -e production
```

And test calling your function:

```bash
$ curl -X POST \
  -H "X-Parse-Application-Id: ${PARSE_APP_ID}" \
  -H "X-Parse-REST-API-Key: ${PARSE_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{}' \
  https://api.parse.com/1/functions/helloWorld
```

Note that if you are using a specific Parse-Server, you may need to change `https://api.parse.com/1`. You should be able to see the response of `{"result":"Hello World!"}`. To unregister the webhooks, you can stop the server and run:

```bash
$ rails parse:webhooks:remove

[-] function - helloWorld
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
