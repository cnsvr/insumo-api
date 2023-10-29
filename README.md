### Insumo Backend API

## Description
    - It is a productivity app that fetches tasks from a mocked third-party platform called "TaskMaster" using Sidekiq for background processing.

## Dependencies
    - Ruby 3.2.2
    - Rails 7.1.1
    - Redis
    - PostgreSQL

## Setup
    - Clone the repository
    - Run `bundle install`
    - Run `rails db:create`
    - Run `rails db:migrate`
    - Run `rails db:seed`
    - Run `rails s`
    - Run `bundle exec sidekiq -C config/sidekiq.yml` to start the background processing
    - Run `bundle exec rspec` to run the tests
    - Run `bundle exec rubocop` to run the linter

## Endpoints
    - GET /get_tasks/:user_id - Fetches all tasks from database for a given user
    - POST /sync_task, body: { user_id: 1 } - Fetches tasks from TaskMaster and saves it to the database


## Background Processing
    - Sidekiq is used for background processing
    - Sidekiq is a simple, efficient background processing for Ruby
    - It retries failed jobs three times by default
    - It uses Redis for storage
    - It is configured in the config/sidekiq.yml file
    - It is started by running `bundle exec sidekiq -C config/sidekiq.yml`
    - Failed jobs can be seen in the Sidekiq UI at http://localhost:3000/sidekiq

## Logs
    - Logs are stored in the log folder
    - Log format is in JSON and customised with JsonLogFormatter class in the lib folder
    - You can run `tail -f log/development.log` to see the logs in real time
    - Sidekiq logs are stored in the SIDEKIQ_LOG_PATH environment variable or in the log/#{Rails.env}_sidekiq.log file. You can run `tail -f log/development_sidekiq.log` to see the logs in real time
    - Also, logs can be sent to a third-party service like Loggly or Papertrail, NewRelic, etc.
