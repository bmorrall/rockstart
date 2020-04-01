# Rockstart
A collection of generators to rapidly start and update ready-to-run Rails Applications.

## Usage
Most applications can be configured using the standard generator:

```bash
bundle exec rails g rockstart
```

For those wanting more control; Rockstart provides a number of generators that can be used as required.

### Postgres
Rockstart creates a config/database.yml suitable for Heroku or Docker installations.

```bash
bundle exec rails g rockstart:postgres
```

### Docker
Rockstart can configure your Rails

```bash
bundle exec rails g rockstart:docker
```

It uses the current Ruby Version, your Rails configuration, along with the current Application Name, to generate a Dockerfile with sensible defaults.

### RSpec

Rockstart can pre-configure RSpec for your repository.

```bash
bundle exec rails g rockstart:rspec
```

### Quality

Rockstart can add tasks for maintaining the quality of your codebase.

```bash
bundle exec rails g rockstart:quality
```

It will install [rubocop-rails](https://github.com/rubocop-hq/rubocop-rails), add a basic set of rule guidelines and auto-generates a configuration file to highlight any existing problems.

Provides a "quality" rake task, which runs all code quality tests on your Application.

```
bundle exec rake quality
```

### Tailwind CSS

[Tailwind CSS](https://tailwindcss.com) is a CSS framework for rapidly prototyping applications.

Install it, via Webpacker, by running:

```bash
bundle exec rails g rockstart:tailwindcss
```

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
