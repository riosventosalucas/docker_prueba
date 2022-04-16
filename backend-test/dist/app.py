from flask import Flask
from flask import jsonify, request
from flask_cors import CORS, cross_origin

app = Flask(__name__)
cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'
  
@app.route('/', methods = ['GET'])
@cross_origin()
def ReturnJSON():
    if(request.method == 'GET'):
        data = {'foo':'bar'}
  
        return jsonify(data)
if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=80)