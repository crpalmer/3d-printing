#!/usr/bin/python3

import json
import machine
import os

output = "orca"

def mkdir_recursive(path):
    base = "."
    for path in path.split('/'):
        base = base + "/" + path
        if not os.path.exists(base):
            os.mkdir(base)

def load_prusa(path, mapping, name_key):
    with open(path) as f:
        orca = {}
        for line in f:
            if line.startswith('['):
                name = line.partition(':')[2].split(']')[0]
                orca[name_key] = name
            else:
                kv = line.partition('=')
                key = kv[0].strip()
                value = kv[2].strip()
                # TODO arrays
                if key in mapping:
                    orca[mapping[key]["key"]] = value
        return orca

def process(path, dest_path, mapping, fixed, name_key):
    has_base_ini = os.path.exists(path + "/base.ini")
    mkdir_recursive(dest_path)
    for file in os.listdir(path):
        full = path + "/" + file
        if os.path.isdir(full):
            process(full, dest_path + "/" + file, mapping, fixed, name_key)
        elif file.endswith(".ini"):
            config = {}
            if not has_base_ini or file == "base.ini":
                config.update(fixed)
            config.update(load_prusa(full, mapping, name_key))
            with open(dest_path + "/" + file[:len(file)-4] + ".json", "w") as output:
                json.dump(config, output, indent=4)

# --------------------------------

mkdir_recursive("orca/filament")
mkdir_recursive("orca/machine")
mkdir_recursive("orca/process")

process("../slic3r/printer", "orca/machine", machine.mapping, machine.fixed, machine.name)
