#!/usr/bin/env bash

if [ ! -e .env ]; then
	touch .env
	echo DB_USER= >> .env
	echo DB_PASSWORD= >> .env
	echo DB_NAME= >> .env
fi