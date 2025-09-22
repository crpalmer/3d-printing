#!/usr/bin/python3

import json
import os

version = "2.3.1.0"

def write_json(dest, config):
    with open(dest, "w") as f:
        print("Creating: " + dest)
        config["version"] = version
        print(config)
        json.dump(config, f, indent=4)

#TODO: this is just a temporary hack
def process(path, dest, name_attr, config = {}, name = None):
    if os.path.exists(path + "/base.json"):
        config.update(json.load(path + "/base.json"))

    for file in os.listdir(path):
        if os.path.isdir(file):
            process(path + "/" + file, dest, config, name)
        elif file.endswith(".json") and not file == "base.json":
            print(file)
            new_config = config
            with open(path + "/" + file, "r") as f:
                new_config.update(json.load(f))
            write_json(dest + "/" + new_config[name_attr] + ".json", new_config)
            
dest = "/home/crpalmer/.config/OrcaSlicer/user/default/"
process("orca/machine", dest + "machine", "printer_settings_id")
