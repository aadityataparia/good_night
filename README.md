# README

## Requirements

- Ruby v3
- Rails v7

## Setup

```
bundle install
rails db:create
rails db:migrate
```

## Run tests

```
rails test
rails rspec
```

## Run Server

```
rails server
```

## Notes

- It is using sqlite local database, so that it is easier to setup
- Current authenticated user `current_user` is taken from `user_id` param in api request, we can replace this by just changing `current_user` logic in future
- It contains both unit tests and integration tests for api
