#!/usr/bin/python3
import sys
import requests

hostname = sys.argv[1]

def download_file(full_fname):
	print("Downloading: " + full_fname)
	response = requests.get("http://" + hostname + "/rr_download?name=/" + full_fname)
	if response.status_code == 200:
		with open(full_fname, "wb") as file:
			file.write(response.content)
	else:
		raise "Failed to download /" + full_fname

def download_directory(dir):
	raw = requests.get("http://" + hostname + "/rr_filelist?dir=/" + dir)
	json = raw.json()

	for entry in json["files"]:
		if entry["type"] == "f":
			download_file(dir + "/" + entry["name"])

download_directory("sys")
download_directory("macros")
