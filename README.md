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

## Comms:
Slack: LabPlus-team #rapu-ture

## Setup

This is a ruby on rails app. You will need to:
* Git clone this repo
```
git clone git@github.com:ServiceInnovationLab/RapuTure.git
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
* Install `rbenv` from https://github.com/rbenv/rbenv then
```
rbenv install < .ruby-version
```
* Install PostgreSQL *(in a Mac)*
```
brew install postgresql
```
* Start PostgreSQL on startup *(in a Mac)*
```
brew services start postgresql
```
* Install PostgreSQL *(in Ubuntu)*
```
apt-get install postgresql postgresql-contrib
```
* Configure PostgreSQL to startup upon server boot *(in Ubuntu)*
```
update-rc.d postgresql enable
```
* Start PostgreSQL *(in Ubuntu)*
```
service postgresql start
```
* Bundler. Install this from gem
```
gem install bundler
```
* Run the setup script
```
bin/setup
```
* Rename `env-example` file to `.env`
* Load seed data from OpenFisca (Note: this takes 15 minutes)
```
bundle exec rake fetch:fetchall
```
* Run the app
```
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
```
bundle exec rubocop
```

* Code Climate - integrated with Travis CI

## Deployment

* Deploys to Heroku via Travis. See `.travis.yml`

## Testing
* Rspec tests are included in the Travis deployment script and can be run locally

```
bundle exec rspec
```
