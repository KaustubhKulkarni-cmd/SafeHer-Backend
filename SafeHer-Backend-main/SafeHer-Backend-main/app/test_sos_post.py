import requests
url='http://127.0.0.1:5000/api/agent/emergency/sos'
payload={'user_id':'123462782984','lat':18.4680993,'lon':73.8657357}
resp=requests.post(url,json=payload)
print('HTTP',resp.status_code)
print('BODY',resp.text)
