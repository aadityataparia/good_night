# README

## Requirements

- Ruby v3
- Rails v7

## Problem Statement

We would like you to implement a "good night" application to let users track when do they go to bed and when do they wake up.

We require some restful APIS to achieve the following:

1. Clock In operation (`POST /clock_ins`), and return all clocked-in times (`GET /clock_ins`), ordered by created time.
2. Users can follow (`POST /follows`) and unfollow (`DELETE /follows`) other users.
3. See the sleep records over the past week for their friends, ordered by the length of their sleep. (`GET /feed`)

Please implement the model, db migrations, and JSON API.
You can assume that there are only two fields on the users "id" and "name".

You do not need to implement any user registration API.

You can use any gems you like.

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
