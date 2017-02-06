from flask import Flask,render_template
import json
import os
import sys

APP_DIR = '/'.join(__file__.split('/')[:-1])
LIB_DIR = os.path.join(APP_DIR, 'lib')
sys.path.append(LIB_DIR)
from config import config_with_app
from routes import routes_with_app

app = Flask(__name__)
app.config['APP_DIR'] = APP_DIR

config_with_app(app)
routes_with_app(app)

if __name__ == '__main__':
    app.run()
