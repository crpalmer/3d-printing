#!/usr/bin/python3

import sys
import requests
import os

host = sys.argv[1]
dir = sys.argv[2]

def upload_dir(dir):
	for file in os.listdir(dir):
		full_path = os.path.join(dir, file)
		if file.startswith(".") or file.endswith(".bak"):
			print("Ignoring " + full_path)
		elif os.path.isfile(full_path):
			os.system("../upload-file.py '" + host + "' '" + full_path + "' '" + full_path + "'")
		elif os.path.isdir(full_path):
			upload_dir(full_path)

upload_dir(dir)
