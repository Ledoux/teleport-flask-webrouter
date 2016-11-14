#!/bin/sh
if [ -d "../../../$(project.config.venv)" ] ; then
  source ../../../$(project.config.venv)/bin/activate
fi
if [ "$MODE" != "localhost" ] ; then
  $(manageExtraConfig) uwsgi -H ../../../$(project.config.venv) --ini config/localhost_uwsgi.ini
else
  $(manageExtraConfig) python scripts/manage.py runserver
fi
