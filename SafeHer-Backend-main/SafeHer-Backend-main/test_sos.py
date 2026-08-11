import sys
sys.path.append('./app')
from flask import Flask, jsonify, request
from agents.emergency_agent import run_emergency_agent

app = Flask(__name__)
@app.route('/sos', methods=['POST'])
def sos():
    return jsonify(run_emergency_agent('test_user', 18.5204, 73.8567))

if __name__ == '__main__':
    with app.test_request_context('/sos', method='POST', json={'user_id':'test', 'lat':1, 'lon':1}):
        try:
            res = app.full_dispatch_request()
            print("Status:", res.status_code)
            print("Response:", res.get_data(as_text=True))
        except Exception as e:
            print("Exception:", e)
