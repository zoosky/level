# [<img src="https://user-images.githubusercontent.com/341387/44155659-8193fca4-a073-11e8-8842-0e2f1cd89627.png" width="150" alt="Level">](https://level.app)

[![CircleCI](https://circleci.com/gh/levelhq/level.svg?style=svg)](https://circleci.com/gh/levelhq/level)

Level is an alternative to real-time chat designed for the software development workflow. 

**Sign up at [level.app](https://level.app)** to reserve your handle and get on the updates list.

## Project Status

Level is currently in the **pre-launch** phase and under active development by a small groups of people. Most tasks are being tracked offline as the foundations of the product come together, in the interest of rapid development and reaching an alpha stage for companies to start using it as quickly as possible.

Interested in helping out? My goal is to (eventually) keep some tasks filed in the [issue tracker](https://github.com/levelhq/level/issues) marked as good candidates for community contribution.

## Developer Setup

You'll need to install the following dependencies first:

- [Elixir](https://elixir-lang.org/install.html) ([version](https://github.com/levelhq/level/blob/master/mix.exs#L4))
- [PostgreSQL](https://postgresapp.com/) 10
- [Yarn](https://yarnpkg.com/en/docs/install)
- [Node](#nodejs) ([version](https://github.com/levelhq/level/blob/master/.nvmrc))

Run the bootstrap script to install the remaining dependencies and create your
development database:

```
cd level
script/bootstrap
```

If your local PostgreSQL install does not have a default `postgres` user, open the `config/dev.secret.exs` file and update the credentials. Then, run the bootstrap script again.

Use the `script/server` command to start up your local server and visit [`localhost:4000`](http://localhost:4000) from your browser.

### Installing Node.js

This repository includes a `.nvmrc` file targeting a specific version of Node
that is known to be compatible with all current node dependencies. Things might work
with a newer version of Node, but the most guaranteed route is to install
[Node Version Manager](https://github.com/creationix/nvm) and run `nvm install` from
the project root.

Then, be sure to run `script/bootstrap` to install node dependencies with the
correct version of node.

### Running tests and analyses

We have a handful of helper scripts available:

- `script/elixir-test`: runs the Elixir test suite with coveralls
- `script/elm-test`: runs the Elm test suite
- `script/test`: runs the Elixir and Elm test suites
- `script/static-analysis`: runs Credo (Elixir linting), Dialyzer, and Elixir formatter verification
- `script/build`: runs all the test suites and static analysis

## Dependencies

The following environment variables must be set in production:

<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Description</th>
    </tr>
  <thead>
  <tbody>
    <tr>
      <td colspan="2"><strong>AWS</strong></td>
    </tr>
    <tr>
      <td><code>AWS_ACCESS_KEY_ID</code></td>
      <td>The AWS access key id for your account (with access to S3).</td>
    </tr>
    <tr>
      <td><code>AWS_SECRET_ACCESS_KEY</code></td>
      <td>The AWS secret access key corresponding to the access key id.</td>
    </tr>
    <tr>
      <td><code>LEVEL_ASSET_STORE_BUCKET</code></td>
      <td>The name of the S3 bucket in which to store uploaded assets.</td>
    </tr>
  </tbody>
  <tbody>
    <tr>
      <td colspan="2"><strong>Host</strong></td>
    </tr>
    <tr>
      <td><code>PORT</code></td>
      <td>The port on which to host the application (typically 80).</td>
    </tr>
    <tr>
      <td><code>LEVEL_HOST</code></td>
      <td>The domain on which you are serving the app (used for generating URLs).</td>
    </tr>
    <tr>
      <td><code>LEVEL_MAILER_HOST</code></td>
      <td>The domain via which to send transaction emails (usually same as <code>LEVEL_HOST</code>).</td>
    </tr>
    <tr>
      <td><code>LEVEL_SECRET_KEY_BASE</code></td>
      <td>A secret key for verifying the integrity of signed cookies.</td>
    </tr>
  </tbody>
  <tbody>
    <tr>
      <td colspan="2"><strong>Database</strong></td>
    </tr>
    <tr>
      <td><code>LEVEL_DATABASE_URL</code></td>
      <td>The URL for the PostgreSQL database.</td>
    </tr>
    <tr>
      <td><code>LEVEL_POOL_SIZE</code></td>
      <td>The maximum number of database connections each process may consume.</td>
    </tr>
  </tbody>
  <tbody>
    <tr>
      <td colspan="2"><strong>SMTP</strong><br>We recommend <a href="https://postmarkapp.com/">Postmark</a>.</td>
    </tr>
    <tr>
      <td><code>LEVEL_SMTP_HOST</code></td>
      <td>The hostname of the your SMTP provider.</td>
    </tr>
    <tr>
      <td><code>LEVEL_SMTP_PORT</code></td>
      <td>The port number for your SMTP provider.</td>
    </tr>
    <tr>
      <td><code>LEVEL_SMTP_USERNAME</code></td>
      <td>The username for your SMTP provider.</td>
    </tr>
    <tr>
      <td><code>LEVEL_SMTP_PASSWORD</code></td>
      <td>The password for your SMTP provider.</td>
    </tr>
  </tbody>
  <tbody>
    <tr>
      <td colspan="2"><strong>Web Push Notifications</strong><br>See instructions here: https://github.com/web-push-libs/web-push#command-line</td>
    </tr>
    <tr>
      <td><code>LEVEL_WEB_PUSH_PUBLIC_KEY</code></td>
      <td>A VAPID public key.</td>
    </tr>
    <tr>
      <td><code>LEVEL_WEB_PUSH_PRIVATE_KEY</code></td>
      <td>A VAPID private key.</td>
    </tr>
  </tbody>
</table>

## Documentation

Run the `script/docs` to generate and view the project ExDocs locally.

## Heroku Deployment (Experimental)

One of our goals is to make self-installation as painless as possible for those who are interested in hosting their own instance.

The relevant configuration files for Heroku live here: 

- [app.json](https://github.com/levelhq/level/blob/master/app.json)
- [elixir_buildpack.config](https://github.com/levelhq/level/blob/master/elixir_buildpack.config)
- [phoenix_static_buildpack.config](https://github.com/levelhq/level/blob/master/phoenix_static_buildpack.config)
- [Procfile](https://github.com/levelhq/level/blob/master/Procfile)

We are aiming to keep seamless Heroku deployment up-to-date, with a few important "alpha software" notes:

- It's possible you may find it broken on master. If you do, please file an issue.
- As deployment needs grow more complex, it may become no longer feasible to support Heroku deploys. Caveat emptor.

### Required additional services

In addition to a Heroku account, you'll need the following services to get your Heroku install up and running:

- An AWS account and an S3 bucket for storing file uploads. You'll be asked for AWS API keys and bucket name environment variables during setup.
- A transactional email provider (we recommend [Postmark](https://postmarkapp.com)). You'll be asked for SMTP host, port, username, and password environment variables during setup.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/levelhq/level/tree/master)

## Copyright

&copy; 2018 Level Technologies, LLC

Licensed under the Apache License, Version 2.0.
