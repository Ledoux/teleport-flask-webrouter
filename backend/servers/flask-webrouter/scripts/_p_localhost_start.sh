#!/bin/sh
if [ "$VIRTUAL_ENV" != "" ] ; then
  VIRTUAL_ENV_OPTION = -H $VIRTUAL_ENV
else
  VIRTUAL_ENV_OPTION = ""
fi
if [ "$MODE" != "localhost" ] ; then
  $(manageExtraConfig) uwsgi $VIRTUAL_ENV_OPTION --ini config/localhost_uwsgi.ini
else
  $(manageExtraConfig) python scripts/manage.py runserver
fi
