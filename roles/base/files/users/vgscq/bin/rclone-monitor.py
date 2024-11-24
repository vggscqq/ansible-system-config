#!/usr/bin/python
import requests
import json
from humanfriendly import format_timespan

def main():
    ip = "127.0.0.1"
    module = "core/stats"
    shares = {"GD" : "5572", "YD" : "5573"}
    ETAReadable = {}

    for share, port in shares.items():
        url = f"http://{ip}:{port}/{module}"
        try:
            response = requests.post(url)
            eta = json.loads(response.text)["eta"]
            
            if eta == None:
                eta = 0

            eta = format_timespan(eta)
            eta = eta.replace(" and ", "").replace(",", "")
            eta = eta.replace(" seconds", "s").replace(" minutes", "m ").replace(" hours", "h")
            eta = eta.replace(" second", "s").replace(" minute", "m ").replace(" hour", "h")
            
            if eta == "0s":
                eta = "Done"

        except Exception as e:
            eta = "Not mounted"
            #print(e)
        ETAReadable[share] = eta

    result = " ".join([f"{share}: {eta};" for share, eta in ETAReadable.items()])
    print(result)

if __name__ == "__main__":
    main()

