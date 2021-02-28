install:
	bundle install --without production

test-watch:
	bundle exec guard

seed:
	rails db:migrate:reset
	rails db:seed

console:
	rails console

fd-build:
	RAILS_ENV=production rails webpacker:compile

fd-dev:
	./bin/webpack-dev-server

cred:
	EDITOR=vim rails credentials:edit
