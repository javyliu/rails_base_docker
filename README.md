# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version: 3.0.0

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
start in production:

use the docker-compose_pro.yml

mkdir log
mkdir storate
mkdir tmp

docker-compose -f docker-compose_pro.yml up
docker-compose exec web bin/rails db:create
docker-compose exec web bin/rails db:migrate

That's ok

