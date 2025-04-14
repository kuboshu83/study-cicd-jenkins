#!/usr/bin/env bash

if [ ! -e .env ]; then
	touch .env
	echo DB_USER=db-user >> .env
	echo DB_PASSWORD=db-user-pass >> .env
	echo DB_NAME=redmine-db >> .env
fi