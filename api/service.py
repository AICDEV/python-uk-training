# open test rest api https://jsonplaceholder.typicode.com/

import requests

res = requests.get("https://jsonplaceholder.typicode.com/todos/1")

if res.status_code == 200:
    data = res.json()

    print(data)
    print(data['userId'])