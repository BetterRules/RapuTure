# Rapu Ture

## Overview
...

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
Developers | [Lyall Morrison](lyall.morrison@ackama.com)
Designers | 
Testers | 
Project Manager | 
Product Owner | 

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
* Install PostgreSQL (in a mac)
```
brew install postgresql
```
* Start PostgreSQL on startup
```
brew services start postgresql
```
* Bundler. Install this from gem
```
gem install bundler
```
* Run the setup script
```
bin/setup
```
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