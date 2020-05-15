# <%= camelized %>

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

## Configuration

<% if auth0? -%>
### Auth0 User Roles

In order to configure User Roles, you need to add a custom [Rule](https://auth0.com/docs/rules) into Auth0 to include the User's current permissions when generating a User.

Access the Admin panel for your Auth0 setup (in Heroku run: `heroku addons:open auth0`), and create a Rule with the following code:

```javascript
function (user, context, callback) {
  var namespace = 'http://<%= app_name %>/';
  var roles = (user.app_metadata && user.app_metadata.roles) || [];
  context.idToken[namespace + 'roles'] = roles;
  context.accessToken[namespace + 'roles'] = roles;
  return callback(null, user, context);
}
```

Find a profile you wish to make an admin, and `"admin"` to a roles array inside of `app_metadata`. For example:

```javascript
{
  "roles": [
    "admin"
  ]
}
```

You should now be able to sign in, with that profile, with Admin access.

<% end -%>
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

<% if auth0? -%>
While every attempt has been made to automate provisioning of apps, you will need to manually configure the User Rule and User Roles within Auth0. Not doing so will disable all Admin functionality.

<% end -%>
* ...
