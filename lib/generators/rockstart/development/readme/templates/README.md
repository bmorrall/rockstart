# <%= camelized %>

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

## Deployment Instructions

### Heroku

<%= camelized %> has been pre-configured to deploy to Heroku; either as a Review app, or directly for Production.

For Production applications, you should already have a git remote with the name `heroku` configured for this application. If this is not found, it will be assumed the app is a review application, and a new deployment will be generated.

Deploy both Review and Production applications by running:

```
bin/deploy-heroku
```

With each deployments, Heroku will automatically run `bin/hooks-release`. Newly provisioned review apps will run `bin/hooks-postdeploy`; which will setup the database, and verify the initial installation was successful.

For new installs; all required addons will be automatically provisioned. You will have to manually add any required addons for any existing applications, as specified within the `app.json` file.

* ...
