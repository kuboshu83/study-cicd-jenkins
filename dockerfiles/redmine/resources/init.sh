#!/usr/bin/env bash

set -e

echo "Run setup script..."
echo "Start Redmine setup ..."

echo "Waiting for database..."
sleep 10

flag_path='/usr/src/redmine/files/default_data_loaded.flag'
if [ -f ${flag_path} ]; then
	echo "Default data already loaded ..."
else
	echo "Load default data ..."
	/docker-entrypoint.sh rails runner "#"
  	RAILS_ENV=production REDMINE_LANG=ja bundle exec rake redmine:load_default_data
	touch ${flag_path}
fi

echo "Start Redmine server ..."
exec /docker-entrypoint.sh rails server -b 0.0.0.0