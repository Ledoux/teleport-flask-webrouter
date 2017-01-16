#!/bin/sh
uwsgi --ini config/$[type.name]_heroku_uwsgi.ini
