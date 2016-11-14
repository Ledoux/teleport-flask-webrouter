#!/bin/sh
if [ -d "../../../$(project.config.venv)" ] ; then
  source ../../../$(project.config.venv)/bin/activate
fi
pip install -r config/base_requirements.txt
