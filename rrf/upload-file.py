#!/usr/bin/python3

import sys
import requests

host = sys.argv[1]
src_file = sys.argv[2]
dest_file = sys.argv[3]

print("Uploading " + dest_file)

with open(src_file, "rb") as file:
	requests.post("http://" + host + "/rr_upload?name=/" + dest_file, data = file)
