from flask import *

# CHANGE THIS
from parselib import parseProductPage

api_parse = Blueprint('api_parse', __name__)

@api_parse.route('/api/v1/parse', methods=['POST'])
def api_parse_route():
	if request.method == 'POST':
		print "/api/v1/parse"

		# Receive json object from mobile request
		# This should show what you received over the network
		jsondata = request.get_json()
		print jsondata


		# IMPLEMENT THIS
		# Parse the url given and..
		# parseResult is a dictionary containing data to be sent to the app
		parseResult = parseProductPage(jsondata['currentURL'])
		return jsonify(
			sample1 = parseResult['sample1'],
			sample2 = parseResult['sample2'],
		)
