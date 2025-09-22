#!/usr/bin/python3

import json
import os

version = "2.3.1.0"

def write_json(dest, config):
    with open(dest, "w") as f:
        print("Creating: " + dest)
        config["version"] = version
        json.dump(config, f, indent=4)

def read_json(path):
    with open(path, "r") as f:
        return json.load(f)

def process_variant_set(path):
    for file in os.listdir(path):
        if file.endswith(".json"):
            variants[file] = read_json(path + "/" + file)

def write_variants(dest, name_attr, config, variants, name):
    None

def process(path, dest, name_attr):
    base_exists = os.path.exists(path + "/base.json")
    if base_exists:
        base_config = read_json(path + "/base.json")

    variants = {}
    for file in os.listdir(path):
        full_file = path + "/" + file
        if os.path.isdir(full_file):
            if base_exists:
                variants[file] = process_variant_set(full_file)
            else:
                process(path + "/" + file, dest, name_attr)
        elif file.endswith(".json") and not file == "base.json":
            print(file)
            if base_exists:
                new_config = base_config
                new_config.update(read_json(full_file))
            else:
                new_config = read_json(full_file)
            print(new_config)
            write_json(dest + "/" + new_config[name_attr] + ".json", new_config)

    if len(variants) > 0:
        write_variants(dest, name_attr, base_config, variants)
            
dest = "/home/crpalmer/.config/OrcaSlicer/user/default/"
process("orca/machine", dest + "machine", "printer_settings_id")
