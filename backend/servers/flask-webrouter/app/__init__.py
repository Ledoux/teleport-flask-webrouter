#
# IMPORTS
#
from flask import Flask,render_template
import json
import os

#
# FLASK
#
app = Flask(__name__)

#
# CONFIG
#
default = {
    'DATA': "localhost",
    'SITE_NAME': "",
    'TEMPLATES': "",
    'TYPE': "localhost",
    'URL': "http://localhost:5000"
}
config = {}
for couples in default.items():
	app.config[couples[0]] = os.environ.get(
		couples[0],
		couples[1]
	)
app.config['HOST_DIR'] = "./" if app.config['TYPE'] != 'localhost' else os.path.join(os.getcwd().split('backend')[0], 'backend/')

#
# FLASK ENV
#
flask_env = {
    "SITE_NAME": app.config["SITE_NAME"],
    "templates": json.loads(app.config["TEMPLATES"]),
    "WEB": app.config["WEB"]
}

#
# ROUTES
#
INDEX_HTML_NAME = '_index.html' if app.config['TYPE'] == 'localhost' else '_index_prod.html'

@app.route('/')
def get_home():
	return render_template(
        INDEX_HTML_NAME,
        **flask_env
    )

@app.route('/ping')
def get_ping():
    return 'ping'

# serve index for all paths, so a client side router can take over
@app.route('/<path:path>')
def get_home_redirect(path):
	return get_home()

#
# RUN
#
if __name__ == '__main__':
    app.run()
