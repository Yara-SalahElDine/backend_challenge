# Backend Challenge


**This app is using Rails 5.2.6 and Ruby 2.6.1**

## Table of contents

- [Tech stack](#tech-stack)
- [Running App](#running-app)
- [API Documentation](#api-documentation)
- [Running Tests](#running-tests)

## Tech stack

- [MySQL](https://www.mysql.com/)
- [Redis](https://redis.io/)
- [Sidekiq](https://github.com/mperham/sidekiq)
- [Elastisearch](https://www.elastic.co/)

## Running App

#### Clone this repo anywhere you want:

```sh
git clone https://github.com/Yara-SalahElDine/backend_challenge.git
```

#### Move into development folder and then Build everything:

```sh
cd development
docker-compose up
```

Once everything is built and all containers are ready, we can start.

## API Documentation

The API Documentation is done using swagger.
#### Check it out in a browser:

Visit <http://localhost:3000/api-docs> in your browser.

## Running Tests

#### To run tests:

```sh
# run this from the terminal
docker exec -it backend_challenge_app  /bin/bash
RAILS_ENV=test bundle exec rspec 
```











