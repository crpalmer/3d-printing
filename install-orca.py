#!/usr/bin/python3

import json
import os

version = "2.3.1.0"
orca_dir = "/home/crpalmer/.config/OrcaSlicer/user/default"

def mkdir_recursive(path):
    if path[0] == '/':
        base = '/'
    else:
        base = "."
    for path in path.split('/'):
        base = base + "/" + path
        if not os.path.exists(base):
            os.mkdir(base)

def get_name(config):
    for key in [ "name", "printer_settings_id" ]:
        if key in config and config[key] != "":
            return config[key]

def set_name(config, name):
    config["name"] = name
    if "printer_settings_id" in config:
        config["printer_settings_id"] = name
    return config

def write_json(dest, config):
    with open(dest, "w") as f:
        print("Creating: " + dest)
        config["version"] = version
        json.dump(config, f, indent=4)

def write_config(config, subsystem, inherits):
    name = get_name(config)
    config["inherits"] = inherits
    config = set_name(config, name)
    write_json(orca_dir + "/" + subsystem + "/" + name + ".json", config)

def write_base(config, subsystem, name):
    config = set_name(config, name)
    config["inherits"] = ""
    write_json(orca_dir + "/" + subsystem + "/base/" + name + ".json", config)

def read_json(path):
    with open(path, "r") as f:
        return json.load(f)

def process(path, subsystem, name):
    for file in os.listdir(path):
        full_file = path + "/" + file
        if os.path.isdir(full_file):
            process(full_file, subsystem, file)
        elif file.endswith(".json"):
            config = read_json(full_file)
            if file == "base.json":
                write_base(config, subsystem, name)
            else:
                write_config(config, subsystem, name)

for subsystem in [ "filament", "machine", "process" ]:
    mkdir_recursive(orca_dir + "/" + subsystem + "/base")
    process("orca/" + subsystem, subsystem, None)
