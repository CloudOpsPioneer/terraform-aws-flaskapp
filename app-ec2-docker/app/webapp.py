# import flask module
from flask import Flask

# instance of flask application
app = Flask(__name__)

# home route that returns below text 
# when root url is accessed
@app.route("/")
def hello_world():
	return "<p>Hello, All!<br>This is Karthikraj!<br>This is my Home page.</p>"

if __name__ == '__main__':
	app.run(debug=True, host='0.0.0.0', port=8001)

