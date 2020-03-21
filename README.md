# Rockstart
A collection of generators to rapidly start and update ready-to-run Rails Applications.

## Usage
Rockstart provides a number of generators that can be used as required.

### Docker
Rockstart can configure your Rails

```bash
bundle exec rails g rockstart:docker
```

It uses the current Ruby Version, your Rails configuration, along with the current Application Name, to generate a Dockerfile with sensible defaults.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'rockstart', group: :development
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install rockstart
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
