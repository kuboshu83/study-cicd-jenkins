#!/usr/bin/env bash

if [ ! -e .env ]; then
	touch .env
	echo DB_USER="please set database user name" >> .env
	echo DB_PASSWORD="please set database user password" >> .env
	echo DB_NAME="please set redmine database name" >> .env
fi