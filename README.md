# Rapu Ture
[![Waffle.io - Columns and their card count](https://badge.waffle.io/ServiceInnovationLab/RapuTure.svg?columns=all)](https://waffle.io/ServiceInnovationLab/RapuTure)
[![Maintainability](https://api.codeclimate.com/v1/badges/580a9cc169de1c21c180/maintainability)](https://codeclimate.com/github/ServiceInnovationLab/RapuTure/maintainability)
[![Build Status](https://travis-ci.org/ServiceInnovationLab/RapuTure.svg?branch=master)](https://travis-ci.org/ServiceInnovationLab/RapuTure)

## Overview

Rapu Ture is a phrase that means "Exploring the rules/law"

This web application presents the variables from within Aotearoa New Zealand's Legislation as Code (Open Fisca) service, as web pages, allowing a user to discover what calculations are available, and where in legislation (or regulation) the rule came from.

## Environments

**Environment** | **URL**  | **Git Branch**
--- | --- | ---
UAT |  | 
Production |  | 

## Project Resources

**Resource** | **URL**
--- | ---
Backlog | https://waffle.io/ServiceInnovationLab/RapuTure
CI | https://travis-ci.org/ServiceInnovationLab/RapuTure

## Documentation

[OpenFisca](https://openfisca.org/doc/)

## People Involved

**Role(s)** | **Name(s)**
--- | ---
Team | Rapu Ture
Developers | [Lyall Morrison](lyall.morrison@ackama.com), [Mischa Saunders](mischa.saunders@ackama.com),  [Brenda Wallace](brenda.wallace@dia.govt.nz), [Dana Iti](dana.iti@dia.govt.nz) & [Jacob Ong](jacob.ong@dia.govt.nz)
Designers | [Siobhan McCarthy](siobhan.mccarthy@dia.govt.nz)
Testers | 
Project Manager | [Charlotte Hinton](charlotte.hinton@dia.govt.nz)
Product Owner | [Brenda Wallace](brenda.wallace@dia.govt.nz)

## Comms:
Slack: LabPlus-team #rapu-ture

## Setup

This is a ruby on rails app. You will need to:
* Git clone this repo
```
git clone git@github.com:ServiceInnovationLab/RapuTure.git
```
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
bundle exec rake fetch:variables
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
