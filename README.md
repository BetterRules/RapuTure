# Rapu Ture

[![Maintainability](https://api.codeclimate.com/v1/badges/580a9cc169de1c21c180/maintainability)](https://codeclimate.com/github/ServiceInnovationLab/RapuTure/maintainability)
[![AwesomeCode Status for ServiceInnovationLab/RapuTure](https://awesomecode.io/projects/26aa53d4-bece-44c7-81d7-6c2f7648adec/status)](https://awesomecode.io/repos/ServiceInnovationLab/RapuTure)
[![Build Status](https://travis-ci.org/ServiceInnovationLab/RapuTure.svg?branch=master)](https://travis-ci.org/ServiceInnovationLab/RapuTure)
[![Test Coverage](https://api.codeclimate.com/v1/badges/580a9cc169de1c21c180/test_coverage)](https://codeclimate.com/github/ServiceInnovationLab/RapuTure/test_coverage)

## Overview

Rapu Ture is a phrase that means "Exploring the rules/law"

This web application presents the variables from within Aotearoa New Zealand's Legislation as Code (Open Fisca) service, as web pages, allowing a user to discover what calculations are available, and where in legislation (or regulation) the rule came from.

## Environments

**Environment** | **URL**  | **Git Branch**
--- | --- | ---
UAT | https://www.rules.nz | master
Production |  |

## Project Resources

**Resource** | **URL**
--- | ---
Backlog | https://github.com/orgs/ServiceInnovationLab/projects/11

## Documentation

[OpenFisca](https://openfisca.org/doc/)

## People Involved

**Role(s)** | **Name(s)**
--- | ---
Team | Rapu Ture
Developers | [Brenda Wallace](https://github.com/Br3nda), [Dana Iti](https://github.com/dlouise64), [Jacob Ong](https://github.com/JacOng17), [Lyall Morrison](https://github.com/lamorrison), [Mischa Saunders](https://github.com/mischa-s)
Designers | [Siobhan McCarthy](https://github.com/ssibbehh)
Testers |
Project Manager | [Charlotte Hinton](https://github.com/CharlotteHinton)
Product Owner | [Brenda Wallace](https://github.com/Br3nda)

## Comms

Slack: LabPlus-team #rapu-ture

## Setup

This is a ruby on rails app. You will need to:

* Git clone this repo

```sh
git clone git@github.com:ServiceInnovationLab/RapuTure.git
```

* You will need to ensure you are using the correct ruby version

```sh
ruby -v
```

Choose one of these tools, to change the ruby version

1. [rbenv](https://github.com/rbenv/rbenv)
2. [rvm](https://rvm.io/)

* You will need to setup the app's environment variables

```sh
cp example.env .env
```

### Docker

This application is configured to run using Docker and docker-compose. You will need [Docker for Desktop](https://www.docker.com/products/docker-desktop) to run this locally.

To set up:

`docker-compose build`

To run:

`docker-compose up`

To fetch data:

`docker exec raputure_web_1 bundle exec rake fetch:fetchall`

To shut down:

`docker-compose down`

### Non-Docker

It can also be set up without Docker. You will need Ruby, Node, and Postgres.

* Install the correct version of Ruby. We recommend installing `rbenv` to manage multiple versions of ruby, and then using that to install the version of ruby specified in our file `.ruby-version`

* Install `rbenv` from [https://github.com/rbenv/rbenv](https://github.com/rbenv/rbenv) then

```sh
rbenv install < .ruby-version
```

---

## In a Mac

Install PostgreSQL

```sh
brew install postgresql
```

Start PostgreSQL on startup

```sh
brew services start postgresql
```

---

## In Ubuntu

Install PostgreSQL

```sh
apt-get install postgresql postgresql-contrib
```

Configure PostgreSQL to startup upon server boot

```sh
update-rc.d postgresql enable

```

Start PostgreSQL

```sh
service postgresql start
```

---

Bundler. Install this from gem

```sh
gem install bundler
```

**Ensure** that your .env file contains these values:

```txt
DATABASE_USERNAME: postgres (we used this as the default)
DATABASE_PASSWORD: <whatever password has been set for that user>
```

Run the setup script

```sh
bin/setup
```

Load seed data from OpenFisca (Note: this takes 15 minutes)

```sh
bundle exec rake fetch:fetchall
```

Run the app

```sh
bundle exec rails server
```

## Development

### Major Dependencies

Ruby 2.5
Rails 5.2 / Puma

* Postgres
* Haml
* React

### Quality assurance tools

* Rubocop

```sh
bundle exec rubocop
```

* Code Climate - integrated with Travis CI

## Deployment

* Deploys to Heroku via Travis. See `.travis.yml`

## Testing

* Rspec tests are included in the Travis deployment script and can be run locally

```sh
bundle exec rspec
```
