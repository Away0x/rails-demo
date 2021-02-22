install:
	bundle install --without production

test-watch:
	bundle exec guard

seed:
	rails db:migrate:reset
	rails db:seed

console:
	rails console

build-frontend:
	RAILS_ENV=production rails webpacker:compile

help:
	@echo "make install - install gems"
	@echo "make test-watch - watch test"
	@echo "make seed - mock database"
	@echo "make console - rails console"
	@echo "build-frontend - build webpack files"